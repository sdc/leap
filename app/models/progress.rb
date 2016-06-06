class Progress < ActiveRecord::Base
  attr_accessible :course_code, :course_status, :course_title, :course_tutor, :course_type, :course_year, :id, :ir_aspiration, :ir_body, :ir_checkbox, :ir_checkbox2, :ir_checkbox3, :ir_checkbox4, :ir_completed, :ir_target_grade, :person_id

  belongs_to :person, :foreign_key => "person_id"

  has_many :progress_reviews
end
