class PersonCourse < Eventable

  delegate :code, :to => :course

  belongs_to :course, :dependent => :destroy
  has_one :enrolment_event,   :as => :eventable, :class_name => "Event", :conditions => {:transition => :start}
  has_one :application_event, :as => :eventable, :class_name => "Event", :conditions => {:transition => :create}
  has_one :complete_event,    :as => :eventable, :class_name => "Event", :conditions => {:transition => :complete}

  after_save do |person_course|
    if person_course.application_date_changed? and person_course.application_date_was == nil
      person_course.events.create(:event_date => person_course.application_date, :transition => :create)
    end
    if person_course.enrolment_date_changed? and person_course.enrolment_date_was == nil
      person_course.events.create(:event_date => person_course.enrolment_date, :transition => :start)
    end
    if person_course.end_date_changed? and person_course.end_date_was == nil
      person_course.events.create(:event_date => person_course.end_date, :transition => :complete)
    end
  end

  def icon_url
    "events/course.png"
  end

  def title(tr)
    "#{course.code} " + case tr
      when :create   then "Application"
      when :start    then "Enrolment"
      when :complete then "Complete" # TODO: distinguish between complete, w/d, incomplete etc
    end
  end

  def body
    "<div class='course_title'><b>#{course.title}</b></div>" +
    "<div class='course_status'>#{status.humanize}</div>" +
    "<div class='course_start'>Start Date: " +
    "#{enrolment_date.strftime("%d %b %Y")}</div>" +
    "<div class='course_end'>End Date: " +
    "#{end_date.strftime("%d %b %Y")}</div>"
  
  end

  def to_xml(options = {})
    super({:include => :course}.merge(options))
  end

end
