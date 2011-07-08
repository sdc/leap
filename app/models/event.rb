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

  validates :person_id,      :presence => true
  validates :event_date,     :presence => true
  validates :eventable_id,   :presence => true
  validates :eventable_type, :presence => true

  belongs_to :person
  belongs_to :about_person, :class_name => "Person", :foreign_key => "about_person_id"
  belongs_to :eventable, :polymorphic => true
  has_many :children, :class_name => "Event", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Event", :foreign_key => "parent_id"
  has_many :targets

  symbolize :transition , :in => [:create,:start,:overdue,:complete,:drop], :methods => true, :scopes => true, :allow_nil => true

  scope :unique_eventable, group("eventable_id,eventable_type")
  scope :creation, where(:transition => :create)

  before_validation {|event| update_attribute("person_id", event.eventable.person_id)}

  delegate :body, :to => :eventable

  [:title,:subtitle,:icon_url,:body,:background_class,:extra_panes,:status,:sanitize_options,:body_partial].each do |method|
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

end
