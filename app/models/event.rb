# Leap - Electronic Individual Learning Plan Software
# Copyright (C) 2011 South Devon College

# Leap is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Leap is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with Leap.  If not, see <http://www.gnu.org/licenses/>.

# = Event
#
# This class handles all the abstracted behaviour that a good event should implement. It's here so that we can
# treat all events polymorphically. All the real work is done in the model for the actual event type that
# we call an eventable. Examples include Target and Note. Events are never created directly,
# this should be done by the eventable.
#
# Event implements four methods which all do pretty much the same thing. title, +subtitle+, +icon_url+ and +body+ each call
# an identically named method, if it exists, in the eventable. If the method in the eventable takes an argument it will be
# passed the event_date from the Event. This allows the eventable to return different information depending on when the
# event happened. This is how Target eventables return different event information before and after their completion date,
# for example.
#

class Event < ActiveRecord::Base
  validates :person_id,      presence: true
  validates :event_date,     presence: true
  validates :eventable_id,   presence: true
  validates :eventable_type, presence: true

  belongs_to :person
  belongs_to :created_by, class_name: "Person", foreign_key: "created_by_id"
  belongs_to :about_person, class_name: "Person", foreign_key: "about_person_id"
  belongs_to :eventable, polymorphic: true
  has_many :children, class_name: "Event", foreign_key: "parent_id", dependent: :nullify
  belongs_to :parent, class_name: "Event", foreign_key: "parent_id"
  has_many :targets, dependent: :nullify

  attr_accessible :event_date, :transition, :parent_id

  TRANSITIONS = [:create, :to_start, :start, :overdue, :complete, :drop, :hidden]

  symbolize :transition, in: TRANSITIONS, methods: true, scopes: true, allow_nil: true

  scope :unique_eventable, -> { group("eventable_id,eventable_type") }
  scope :creation, -> { where(transition: :create) }
  scope :this_year, -> { where("event_date > ?", year_start) }
  default_scope -> { order("event_date DESC") }

  before_validation { |event| update_attribute("person_id", event.eventable.person_id) unless person_id }
  before_create do |event|
    event.event_date = event.eventable.created_at unless event_date
    event.created_by_id = Person.user ? Person.user.id : nil unless event.created_by_id
  end

  delegate :body,  to: :eventable
  delegate :past?, to: :event_date

  attr_accessor :first_in_past

  def self.year_start
    @date = Date.today
    (d, m) = Settings.year_boundary_date.split("/").map(&:to_i)
    ab = @date.change(day: d, month: m)
    if ab < @date
      @date = ab
      @end_date = ab
    else
      @end_date = ab
      @date = ab - 1.year
    end
  end

  [:title, :subtitle, :icon_url, :body, :extra_panes, :status, :staff_only?,
   :timetable_length, :tile_bg, :tile_icon, :tile_title, :is_deleted?].each do |method|
    define_method method do
      if eventable.respond_to?(method)
        m = eventable.method(method)
        if m.arity == 1
          m.call(transition)
        else
          m.call
        end
      end
    end
  end

  def first_in_past?; first_in_past; end

  def to_xml(options = {}, &_block)
    super(options.reverse_merge(include: :eventable))
  end

  def is_deletable?
    return true if Person.user.staff? && eventable_type == "Qualification"
    Person.user.admin? || (Time.now - Settings.delete_delay.to_i < eventable.created_at && Person.user == eventable.created_by)
  end

  def created_by_text(options = {})
    options.reverse_merge!(event: true, eventable: true)
    ret = (created_by && options[:event]) ? "Event created by #{created_by.name}<br />" : ""
    ret += eventable.created_by_text if options[:eventable]
  end

  def timetable_start
    event_date
  end

  def timetable_margin
    ((timetable_start - timetable_start.change(hour: 8, minute: 0, sec: 0, usec: 0)) / 50).floor
  end

  def timetable_height
    (timetable_length / 56).floor
  end

  def timetable_end
    event_date + timetable_length
  end

  def to_tile
    attrs = {
      title: tile_title || title,
      bg: tile_bg,
      icon: tile_icon,
      is_deletable: is_deletable?,
      subtitle: subtitle,
      body: body,
      person_id: person_id,
      object: self
    }
    if eventable.respond_to? :tile_attrs
      if eventable.method(:tile_attrs).arity == 1
        attrs.merge!(eventable.tile_attrs(transition))
      else
        attrs.merge!(eventable.tile_attrs)
      end
    end
    Tile.new attrs
  end

  def cl_status
    "info"
  end
end
