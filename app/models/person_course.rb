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

class PersonCourse < Eventable

  include MisPersonCourse

  delegate :code, :vague_title, :entry_reqs, :to => :course
  delegate :photo_uri, :name, :mis_id, :note, :contact_allowed, :staff?, :to => :person

  belongs_to :course
  belongs_to :person
  has_one :enrolment_event, -> { where :transition => :start },    :as => :eventable, :class_name => "Event"
  has_one :application_event, -> { where :transition => :create }, :as => :eventable, :class_name => "Event"
  has_one :complete_event, -> { where :transition => :complete },  :as => :eventable, :class_name => "Event"

  attr_accessible :offer_code, :status, :start_date, :application_date, :mis_status, :person_id, :course_id

  after_save do |person_course|
    if person_course.application_date_changed? and person_course.application_date_was == nil
      person_course.events.create(:event_date => person_course.application_date, :transition => :create)
    end
    if person_course.enrolment_date_changed? and person_course.enrolment_date_was == nil
      person_course.events.create(:event_date => person_course.enrolment_date, :transition => :to_start)
    end
    if person_course.start_date_changed? and person_course.start_date_was == nil
      person_course.events.create(:event_date => person_course.start_date, :transition => :start)
    end
    if person_course.end_date_changed? and person_course.end_date_was == nil
      person_course.events.create(:event_date => person_course.end_date, :transition => :complete)
    end
  end

  def icon_url
    "events/course.png"
  end

  def icon_class
    "fa-book"
  end

  def title(tr)
    [course, case tr
      when :create   then "Application"
      when :to_start then "Enrolment"
      when :start    then "Start"
      when :complete then "Complete" # TODO: distinguish between complete, w/d, incomplete etc
    end]
  end

  def to_xml(options = {})
    super({:include => :course}.merge(options))
  end

  def status 
    if self[:status] == "current"
      if start_date
        start_date <= Date.today ? "current" : "not_started"
      else
        "unknown"
      end
    else
      self[:status]
    end
  end

  def cl_status
    {"unknown"    => "default",
     "complete"   => "success",
     "current"    => "warning",
     "incomplete" => "danger"
    }[status] or "default"
  end

  def extra_panes(tr)
    panes = ActiveSupport::OrderedHash.new
    if tr == :create 
      unless entry_reqs.empty?
        panes["Entry Requirements"] = "events/tabs/entry_reqs"
      end
      if !Settings.application_title_field.blank? and Person.user.staff?
        panes["Meeting outcome"]  = "events/tabs/application_offer"
      end
    end
    return panes
  end

  def tile_attrs
    {:icon => "fa-graduation-cap"}
  end

  def mis_status
    self[:mis_status] || ""
  end

end
