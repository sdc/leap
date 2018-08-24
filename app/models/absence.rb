# class Absence < ActiveRecord::Base
class Absence < Eventable

  REASONS = ["Work",
             "Transport Problems",
             "Medical Appointment",
             "Sickness",
             "Holiday",
             "Personal Reasons",
             "Family Issues",
             "Job Interview",
             "Bereavement/Funeral",
             "Adverse Weather",
             "Bad Timekeeping",
             "Requires Attention",
	           "Unable to Contact",
	           "Suspended",
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
  has_many   :register_event_details_slots, :through => :absence_slots, :order => "planned_start_date"
  has_many   :messages, :as => :attachment

  validates_presence_of "person_id"

  # def self.icon
  #   "http://eilp.southdevon.ac.uk/images/absence.png"
  # end

  # def icon
  #   "http://eilp.southdevon.ac.uk/images/#{(usage_code or "k").downcase}.png"
  # end

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

# class Absence < Ebs::Model

#   REASONS = ["Work",
#              "Transport Problems",
#              "Medical Appointment",
#              "Sickness",
#              "Holiday",
#              "Personal Reasons",
#              "Family Issues",
#              "Job Interview",
#              "Bereavement/Funeral",
#              "Adverse Weather",
#              "Bad Timekeeping",
#              "Requires Attention",
#              "Unable to Contact",
#              "Suspended",
#              "Other"
#             ]

#   CONTACT = ["Phone call from student",
#              "Phone call from parent",
#              "Email",
#              "Signed in late",
#              "Signed out early",
#              "Informed by tutor",
#              "SDC Contacted - Parent",
#              "SDC Contacted - Student",
#              "SDC Contacted - Other",
#              "College Staff",
#              "Unable to Contact"
#             ]

#   belongs_to :person
#   attr_accessible :lessons_missed, :reason, :reason_extra, :usage_code, :contact, :created_at, :deleted, :from_date, :person_id

#   validates_presence_of "person_id"
#   # self.table_name= "addresses"
#   self.table_name= "sdc_ilp_absences"

#   # default_scope where(:owner_type => "P")
#   # self.primary_key= "owner_ref"

#   # belongs_to :person,  :foreign_key => "owner_ref"

#   # def postcode
#   #   (uk_post_code_pt1 || "") + " " + (uk_post_code_pt2 || "")
#   # end

# end
