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
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

class PersonCourse < Eventable

  delegate :code, :to => :course

  belongs_to :course
  has_one :enrolment_event,   :as => :eventable, :class_name => "Event", :conditions => {:transition => :start}
  has_one :application_event, :as => :eventable, :class_name => "Event", :conditions => {:transition => :create}
  has_one :complete_event,    :as => :eventable, :class_name => "Event", :conditions => {:transition => :complete}

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
      start_date <= Date.today ? "current" : "not_started"
    else
      self[:status]
    end
  end

end
