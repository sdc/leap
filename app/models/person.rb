class Person < ActiveRecord::Base

  has_many :events
  has_many :person_courses
  has_many :courses, :through => :person_courses
  
  serialize :middle_names
  serialize :address
  serialize :cars

  def to_param
    uln.to_s
  end

  def name(options = {})
    names = [forename]
    names += middle_names if options[:middle_names]
    if options[:surname_first]
      names.unshift "#{surname},"
    else
      names.push surname
    end
    names.join " "
  end

  def Person.get(uln,fresh=false)
    (fresh ? false : find_by_uln(uln)) or MisConnector.get_person(uln)
  end

end
