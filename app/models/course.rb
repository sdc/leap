class Course < ActiveRecord::Base

  include MisCourse

  has_many :person_courses
  has_many :people, :through => :person_courses

  def Course.get(mis_id,fresh=false)
    (fresh ? import(mis_id, :people => true) : find_by_mis_id(mis_id)) or import(mis_id, :courses => true)
  end

  def name
    title
  end

  def to_param
    mis_id.to_s
  end

  def as_param
    {:course_id => mis_id.to_s}
  end

end
