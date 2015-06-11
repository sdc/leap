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

# = Target
#
# These are (hopefully) SMART targets stored against a person. They can be attached to any other event in the system, usually
# taken to be the event which inspired the target or towards which the target is working.
#
# This model is eventable. It creates two events when set, one showing the creation of the target and one as a reminder of the target's
# completion date. When it is completed it new event noting its completion.
#
class Target < Eventable
  validates :target_date, :body, presence: true

  belongs_to :set_by, class_name: "Person", foreign_key: "set_by_person_id"
  #belongs_to :event

  after_create do |target|
    target.events.create(event_date: created_at, parent_id: parent_id, transition: :start)
    target.events.create(event_date: target_date, transition: :overdue)
  end

  after_save do |target|
    if target.complete_date_changed? && target.complete_date_was.nil?
      events.create!(event_date: complete_date, transition: :complete)
    end
    if target.drop_date_changed? && target.drop_date_was.nil?
      events.create!(event_date: drop_date, transition: :drop)
    end
  end

  # Returns the target eventable icon url. Complete or not?
  def font_icon
    case status
    when :complete   then "fa-bullseye"
    when :incomplete then "fa-bullseye"
    else "fa-bullseye"
    end
  end

  # Returns the target eventable title.
  def title(tr)
    case tr
    when :complete then "Completed a target"
    when :start    then "Set a target"
    when :drop     then "Dropped a target"
    else "Target is due"
    end
  end

  # Returns the status for this event, it is +:current+ unless it is a completion event, when it is +:complete+.
  # TODO: Have an incomplete status too.
  def status
    if complete_date
      :complete
    elsif drop_date
      :incomplete
    elsif target_date < Time.now
      :overdue
    else
      :current
    end
  end

  # Returns the partial to render for the details pane
  def extra_panes
    [["Completion", "targets/details"]]
  end

  def tile_attrs
    { icon: "fa-bullseye",
      title: "Target",
      subtitle: nil,
      partial_path: "tiles/target" }
  end

  def as_timeline_event(e)
    { verb: case e.transition
            when :start     then "set a target to"
            when :overdue   then "am aiming to"
            when :completed then "completed a target to"
            when :drop      then "dropped a target to"
            end,
      title: body.sub(/\W$/,''),
      targetDate: target_date,
      iconUrl: icon_url
    }
  end
end
