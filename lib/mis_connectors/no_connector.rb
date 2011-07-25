module MisPerson

  def self.included receiver
    receiver.extend ClassMethods
  end

  module ClassMethods

    def connector
      "No connector"
    end

    def import(mis_id)
      return Person.find_by_mis_id(mis_id) || false
    end
  end

  def photo_path
    return "/images/noone.png"
  end

  def import_courses
      return Person.find_by_mis_id(mis_id) || false
  end
  
  def timetable_events(*junk)
    return []
  end

end

module MisCourse

  def self.included receiver
    receiver.extend ClassMethods
  end

  module ClassMethods
    def import(mis_id)
      return Course.find_by_mis_id(mis_id) || false
    end
  end

end

module MisQualification
end
