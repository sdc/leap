class PersonCourse < ActiveRecord::Base

  belongs_to :person, :dependent => :destroy
  belongs_to :course, :dependent => :destroy
  has_many :events, :as => :eventable, :dependent => :destroy

  after_save do |person_course|
    ["application_date","enrolment_date","end_date"].each do |attr|
      if person_course.send("#{attr}_changed?") and person_course.send("#{attr}_was") == nil
        person_course.events.create!(:event_date => person_course.send(attr))
      end
    end
  end

  def icon_url
    "events/course.png"
  end

  def title(date)
    case date
      when application_date then "Application"
      when enrolment_date then "Enrolment"
      when end_date then "Completion" # TODO: distinguish between complete, w/d, incomplete etc
    end
  end

  def body
    course.name
  end

  def background_class
    case status
    when "active"  : "bg_status"
    when "success" : "bg_success"
    when "fail"    : "bg_fail"
    end
  end

end
