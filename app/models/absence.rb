# class Absence < ActiveRecord::Base
class Absence < Eventable

  # REASONS = ["Work",
  #            "Transport Problems",
  #            "Medical Appointment",
  #            "Sickness",
  #            "Holiday",
  #            "Personal Reasons",
  #            "Family Issues",
  #            "Job Interview",
  #            "Bereavement/Funeral",
  #            "Adverse Weather",
  #            "Bad Timekeeping",
  #            "Requires Attention",
	 #           "Unable to Contact",
	 #           "Suspended",
  #            "Other"
  #           ]

  REASONS = ["Medical appt that cannot be rearranged outside of college hours (acceptable)",
             "Recognised Religious holidays (acceptable)",
             "University Open Day or career related interview or audition (acceptable)",
             "Attendance at a funeral (acceptable)",
             "A Driving test (acceptable)",
             "A course reps meeting (acceptable)",
             "Sickness (acceptable)",
             "Family emergency / bereavement (acceptable)",
             "Holiday (unacceptable)",
             "Paid or unpaid work that is not part of the course (unacceptable)",
             "Non-urgent medical appointments that could be arranged outside of lessons (unacceptable)",
             "Birthdays or similar celebrations (unacceptable)",
             "Babysitting younger siblings (unacceptable)",
             "Driving Lessons (unacceptable)",
             "Other"
            ]            

  CONTACT = ["Phone call from student",
             "Phone call from parent",
             "Email",
             "Signed in late",
             "Signed out early",
             "Informed by tutor",
      	     "SDC Contacted - Parent",
      	     "SDC Contacted - Student",
      	     "SDC Contacted - Other",
      	     "College Staff",
             "Unable to Contact"
            ]

  attr_accessible :lessons_missed, :category, :body, :usage_code, :notified_at, :contact_category, :created_at, :deleted, :from_date, :person_id, :created_by_id, :updated_at, :start_date, :end_date
  # alias_attribute :reason, :category

  after_create {|ab| ab.events.create!(:event_date => created_at, :transition => :create)}


  belongs_to :person
  has_many   :absence_slots, :dependent => :destroy
  has_many   :register_event_details_slots, -> { order(:planned_start_date) }, :through => :absence_slots
  has_many   :messages, :as => :attachment

  validates_presence_of "person_id"

  def subtitle
    usage_code
  end

  def status
    Ilp2::Application.config.mis_usage_codes[usage_code]
  end  

  def send_message
    register_event_details_slots.map{|s| s.register_event.teachers}.flatten.uniq.each do |to|
        Message.create(:attachment_type => "Absence",
                       :attachment_id   => id,
                       :title           => "Learner reported absence",
                       :person_from     => person,
                       :person_to       => to
                      )
    end
  end

end
