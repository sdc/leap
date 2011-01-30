class Course < ActiveRecord::Base

  has_many :person_courses
  has_many :people, :through => :person_courses

  def name(options = {})
    title + " (#{code})"
  end

  def Course.get(mis_id,fresh=false)
    (fresh ? false : find_by_mis_id(mis_id)) or MisConnector.get_course(mis_id)
  end

end
