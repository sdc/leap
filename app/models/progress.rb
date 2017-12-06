class Progress < ActiveRecord::Base
  attr_accessible :course_code, :course_status, :course_title, :course_tutor, :course_type, :course_year, :id, :person_id, :uio_id
  attr_accessor :initial, :attendance, :reviews

  belongs_to :person, :foreign_key => "person_id"

  has_many :progress_reviews
  has_many :initial_reviews
  belongs_to :tutor, :class_name => "Person", :foreign_key => "course_tutor_id"

  scope :only_par_type, -> (type) { where par_type: type }

  def bksb_english_da
    self[:bksb_english_da] || 'N/A'
  end

  def bksb_english_ia
    self[:bksb_english_ia] || 'N/A'
  end

  def bksb_maths_da
    self[:bksb_maths_da] || 'N/A'
  end

  def bksb_maths_ia
    self[:bksb_maths_ia] || 'N/A'
  end

  def qca_score
    self[:qca_score] || 'N/A'
  end

  def nat_target_grade
    self[:nat_target_grade] || 'N/A'
  end

  def subject_grade
    self[:subject_grade] || 'N/A'
  end

  def show_par_reviews
    ["FULLTIME",nil].include? self[:par_type] || nil
  end

end
