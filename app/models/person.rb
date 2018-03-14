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

require 'misc/misc_dates'

class Person < ActiveRecord::Base

  include MisPerson

  scoped_search :on => [:forename, :surname, :mis_id]

  AFFILIATIONS = ["staff","student","applicant","affiliate"]

  has_many :events
  has_many :review_lines
  has_many :person_courses
  has_many :courses, :through => :person_courses
  has_many :attendances
  has_many :notes
  has_many :targets
  has_many :contact_logs
  has_many :goals
  has_many :disciplinaries
  has_many :qualifications
  has_many :support_requests
  has_many :support_strategies
  has_many :support_histories
  has_many :reviews
  has_many :absences
  has_many :progression_reviews
  has_many :interventions
  has_many :profile_questions
  has_many :achievements
  has_many :entry_req_mets
  has_many :pathways
  has_many :tt_activities
  has_many :simple_poll_answers
  has_many :event_notes
  has_many :mdl_grade_tracks
  has_many :mdl_badges
  has_many :work_packages
  has_many :progresses
  has_many :progress_reviews
  has_many :initial_reviews
  has_many :aspirations
  has_many :induction_questions
  has_many :notifications
  has_many :support_plps
  has_many :lsf_bursary_funds

  has_many  :continuing_learnings, :class_name => "ContinuingLearning", :foreign_key => "leap_person_id"

  belongs_to :tutor, :class_name => "Person", :foreign_key => "tutor_id"
  
  serialize :middle_names
  serialize :address
  serialize :my_courses

  attr_accessible :mis_id, :forename, :surname, :middle_names, :address, :town, :postcode, :mobile_number, :photo, :next_of_kin, :date_of_birth, :staff, :username, :personal_email, :home_phone, :note, :contact_allowed

  def self.me
    # Convinience method to get Kev at SDC
    Person.get(10083332)
  end

  def age
    age_on(Date.today)
  end

  def age_on(date)
    # ((date.to_date - date_of_birth.to_date)/365).to_i
    return nil unless defined?(date.to_date)
    return nil unless defined?(date_of_birth.to_date)
    day_diff = date.day - date_of_birth.day
    month_diff = date.month - date_of_birth.month - (day_diff < 0 ? 1 : 0)
    date.year - date_of_birth.year - (month_diff < 0 ? 1 : 0)
  end

  def to_param
    mis_id.to_s
  end

  def attendance(course_type = "overall")
    course_type = course_type.to_s
    Rails.cache.fetch("#{mis_id}_#{course_type}_attendance", :expires_in => 8.hours) do
      attendances.where(:course_type => course_type).last
    end
  end

  def attendance_acyr(course_type = "overall", ay)
    course_type = course_type.to_s
    Rails.cache.fetch("#{mis_id}_#{course_type}_attendance", :expires_in => 8.hours) do
      attendances.where( :course_type => course_type, MISC::MiscDates.date_in_acyr(:created_at,ay) => true ).last
    end
  end

  def Person.get(mis_id,fresh=false)
    mis_id = mis_id.to_s.tr('^0-9','') if mis_id.to_s.match(/\d{6}/)
    return import(mis_id) if fresh
    return find_by_username(mis_id) || find_by_mis_id(mis_id) || import(mis_id)
  end
   
  def name(options = {})
    names = [forename]
    names += middle_names if options[:middle_names] and middle_names
    if options[:surname_first]
      names.unshift "#{surname},"
    else
      names.push surname
    end
    names.join " "
  end

  def short_name
    forename[0,1]+' '+surname
  end

  def self.user
    Thread.current[:user]
  end

  def self.user=(user)
    Thread.current[:user] = user
  end

  def self.affiliation
    Thread.current[:affiliation]
  end

  def self.affiliation=(affiliation)
    Thread.current[:affiliation] = affiliation
  end

  def current_user?
     self == Person.user
  end

  def as_param
    {:person_id => mis_id.to_s}
  end

  def staff?
    current_user? ? (Person.affiliation == "staff") : self[:staff]
  end

  def admin?
    Settings.admin_users.map{|x| x.to_i}.include? id
  end

  def superuser?
    ["owenwiddicombe","jameskamradcliffe"].include? Person.user.username
  end

  def can_edit_grade?
    return true if Person.user.superuser?
    return true if Person.user.admin? && Settings.par_window_type.present?
    return true if Person.user.staff? && Settings.par_window_type.present?
    return false
  end

  def mis_code
    mis_id
  end

  def code
    mis_id
  end

  def photo_uri
    if Settings.lorem_pictures.blank?
      if photo
        "data:image/jpeg;base64," + ::Base64.encode64(photo)
        # "data:image/jpeg;base64," + ActiveSupport::Base64.encode64(photo)
      else
        "noone.png"
      end
    else
      "http://lorempixel.com/130/130/#{Settings.lorem_pictures}/#{id.to_s.last}"
    end
  end

  def lat_score
    Rails.cache.fetch("#{mis_id}_l3va_score", :expires_in => 1.hour) do
      if qualifications.detect{|q| q.lat_score.kind_of? Fixnum}
        (qualifications.select{|q| q.lat_score.kind_of? Fixnum}.sum{|q| q.lat_score} / 
         qualifications.select{|q| q.lat_score.kind_of? Fixnum}.count.to_f).round(2)
      else
        false
      end
    end
  end

  def l3va; lat_score end

  def gcse_english
    qualifications.where(:qual_type => "GCSE", :predicted => false).where("LOWER(title) = ?", "english language").last.try :grade
  end

  def gcse_maths
    qualifications.where(:qual_type => "GCSE", :predicted => false).where("LOWER(title) LIKE ?", "math%").last.try :grade
  end
 
  def target_english
    mdl_grade_tracks.where(course_type: "english").where("tag is not null").try :tag
  end

  def address_text
    address.blank? ? nil : [address, town, postcode].reject(&:nil?).join(", ")
  end

  def person?; true end
  def course?; false end

  def possessive_name( str_if_blank='Your' )
    defined?( forename ) && forename? ? forename.split(' ')[0]+((forename.split(' ')[0][-1].downcase) == 's' ? "'" : "'s") : str_if_blank
  end

  def can_add_intervention_stage( new_stage )
    return true if !( (new_stage =~ /^Stage_[123]_Attendance_Disc/).present? || (new_stage =~ /^Stage_[123]_Behaviour_Disc/).present? || (new_stage =~ /^Stage_[123]_Progress_Intervention/).present? )

    stage_left = new_stage[0..5]
    stage_right = new_stage[7..255]
    try_stage = new_stage[6].to_i
    previous_stage = ((try_stage-1) .. (try_stage-1)).to_a.to_s
    next_stages = try_stage.upto( 3 ).to_a.to_s.gsub(', ','')

    return true  if (new_stage =~ /^Stage_3_Behaviour_Disc/).present?  # always allow Stage 3 disciplinary selection
    return false if interventions.map{ |x| x.pi_type if x.status == :current && MISC::MiscDates.acyr(x.created_at) == MISC::MiscDates.acyr }.select{ |y| /^#{stage_left}[123]#{stage_right}/ =~ y }.present?  # do not allow if there is an open Stage 1 2 or 3
    return false if try_stage > 1 && !(interventions.map{ |x| x.pi_type if MISC::MiscDates.acyr(x.created_at) == MISC::MiscDates.acyr }.select{ |y| /^#{stage_left}#{previous_stage}#{stage_right}/ =~ y }.present?) # do not allow if want Stage 2 or 3 but there is no Stage 1 or 2 repectively
    return false if interventions.map{ |x| x.pi_type if MISC::MiscDates.acyr(x.created_at) == MISC::MiscDates.acyr }.select{ |y| /^#{stage_left}#{next_stages}#{stage_right}/ =~ y }.present?   # do not allow if want Stage x but already Stage x or higher exists
    return true
  end

end
