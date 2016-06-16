class Progress < ActiveRecord::Base
  attr_accessible :course_code, :course_status, :course_title, :course_tutor, :course_type, :course_year, :id, :person_id, :uio_id

  belongs_to :person, :foreign_key => "person_id"

  has_many :progress_reviews
  has_many :initial_reviews
  belongs_to :tutor, :class_name => "Person", :foreign_key => "course_tutor_id"

  def bg
    begin
      if att_year < Settings.attendance_low_score.to_i
        return "a66"
      elsif att_year < Settings.attendance_high_score.to_i
        return "da6"
      else
        return "6a6"
      end
    rescue
      return "6a6"
    end
  end
  
end
