class Person < ActiveRecord::Base

  include MisPerson

  scoped_search :on => [:forename, :surname]

  has_many :events
  has_many :reviews
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
  
  serialize :middle_names
  serialize :address
  serialize :cars

  def to_param
    mis_id.to_s
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

  def Person.get(mis_id,fresh=false)
    (fresh ? false : find_by_mis_id(mis_id)) or import(mis_id)
  end

  def self.user
    Thread.current[:user]
  end

  def self.user=(user)
    Thread.current[:user] = user.id
  end

end
