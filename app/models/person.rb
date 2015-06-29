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

require 'base64' 

class Person < ActiveRecord::Base
  require 'identicon'
  include MisPerson

  #attr_accessible :forename, :surname, :middle_names, :address, :town, :postcode, :photo, 
  #                 :mobile_number, :next_of_kin, :date_of_birth, :mis_id, :staff, :username, 
  #                 :personal_email, :home_phone, :note

  scoped_search on: [:forename, :surname, :mis_id]

  AFFILIATIONS = %w(staff student applicant affiliate)

  has_many :events
  has_many :review_lines
  has_many :person_courses
  has_many :courses, through: :person_courses
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
  has_many :learning_actions
  belongs_to :tutor, class_name: "Person", foreign_key: "tutor_id"

  serialize :middle_names
  serialize :address
  serialize :my_courses

  def self.me
    # Convinience method to get Kev at SDC
    Person.get(10083332)
  end

  def age
    age_on(Date.today)
  end

  def age_on(date)
    return nil unless date_of_birth
    ((date.to_date - date_of_birth.to_date) / 365).to_i
  end

  def to_param
    mis_id.to_s
  end

  def attendance(course_type = "overall")
    course_type = course_type.to_s
    Rails.cache.fetch("#{mis_id}_#{course_type}_attendance", expires_in: 8.hours) do
      attendances.where(course_type: course_type).last
    end
  end

  def attendance_data
    Hash[Category.all.map do |c|
      [c.title.downcase, attendance(c.title.downcase)]
    end].merge({overall: attendance})
  end

  def grade_data
    Hash[Category.all.map do |c|
      #[c.title.downcase, events.where(eventable_type: "MdlGradeTrack", category_id: c.id).last]
      [c.title.downcase, mdl_grade_tracks.where(course_type: c.title).last]
    end]
  end

  def current_review 
    reviews.where(window: Settings.current_review_window).first
  end

  def pi_count
    events.where(:eventable_type => "Intervention", :transition => :create).count
  end

  def self.get(mis_id, fresh = false)
    mis_id = mis_id.to_s.tr('^0-9', '') if mis_id.to_s.match(/\d{6}/)
    return import(mis_id) if fresh
    find_by_username(mis_id) || find_by_mis_id(mis_id) || import(mis_id)
  end

  def name(options = {})
    names = [forename]
    names += middle_names if options[:middle_names] && middle_names
    if options[:surname_first]
      names.unshift "#{surname},"
    else
      names.push surname
    end
    names.join " "
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
    { person_id: mis_id.to_s }
  end

  def staff?
    current_user? ? (Person.affiliation == "staff") : self[:staff]
  end

  def admin?
    Settings.admin_users.map(&:to_i).include? id
  end

  def staff; staff? end
  def admin; admin? end

  def mis_code
    mis_id
  end

  def code
    mis_id
  end

  def photo_uri
    if Settings.lorem_pictures.blank?
      if photo
        "data:image/jpeg;base64," + Base64.encode64(photo)
        #"/people/#{mis_id}.jpg"
      else
        Identicon.data_url_for mis_id
      end
    else
      "http://lorempixel.com/130/130/#{Settings.lorem_pictures}/#{id.to_s.last}"
    end
  end

  def lat_score
    Rails.cache.fetch("#{mis_id}_l3va_score", expires_in: 1.hour) do
      if qualifications.detect { |q| q.lat_score.kind_of? Fixnum }
        (qualifications.select { |q| q.lat_score.kind_of? Fixnum }.sum(&:lat_score) /
         qualifications.select { |q| q.lat_score.kind_of? Fixnum }.count.to_f).round(2)
      else
        false
      end
    end
  end

  def address_text
    address.blank? ? nil : [address, town, postcode].reject(&:nil?).join(", ")
  end

  def person?; true end

  def course?; false end

  def topic_type; "person" end

  def as_json(options = {})
    json_methods  = %w(name staff photo_uri admin topic_type lat_score attendance_data grade_data current_review pi_count)
    json_methods += %w(address_text age) if current_user? || !staff?
    json_only     = %w(forename surname contact_allowed mis_id)
    json_only    += %w(note date_of_birth mobile_number home_phone 
                       next_of_kin personal_email postcode town my_courses) if current_user? || !staff?
    super options.merge(methods: json_methods, only: json_only)
  end
end
