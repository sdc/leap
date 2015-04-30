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

  belongs_to :course
  belongs_to :person

  #attr_accessible :offer_code, :status, :start_date, :application_date, :mis_status

  after_save do |person_course|
    if person_course.application_date_changed? && person_course.application_date_was.nil?
      person_course.events.create(event_date: person_course.application_date, transition: :create)
    end
    if person_course.enrolment_date_changed? && person_course.enrolment_date_was.nil?
      person_course.events.create(event_date: person_course.enrolment_date, transition: :to_start)
    end
    if person_course.start_date_changed? && person_course.start_date_was.nil?
      person_course.events.create(event_date: person_course.start_date, transition: :start)
    end
    if person_course.end_date_changed? && person_course.end_date_was.nil?
      person_course.events.create(event_date: person_course.end_date, transition: :complete)
    end
  end

  def extra_panes(tr)
    panes = ActiveSupport::OrderedHash.new
    if tr == :create
      unless entry_reqs.empty?
        panes["Entry Requirements"] = "events/tabs/entry_reqs"
      end
      if !Settings.application_title_field.blank? && Person.user.staff?
        panes["Meeting outcome"]  = "events/tabs/application_offer"
      end
    end
    panes
  end

  def font_icon
    "fa-graduation-cap"
  end

  def timeline_template
    "person_course.html"
  end

  def timeline_attrs(tr)
    {
     status: mis_status,
     applicationTitle: course.vague_title,
     offerCode: offer_code,
     courseId: course.mis_id,
     courseTitle: course.name,
     courseCode: course.code,
     tutorGroup: tutorgroup,
     startDate: start_date,
     endDate: end_date,
     verb: case tr
           when :create   then "Applied for"
           when :to_start then "Enrolled on"
           when :start    then "Started"
           when :complete then status == "complete" ? "Completed" : "Finished"
           end
    }
  end
end
