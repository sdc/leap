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
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

class Person < ActiveRecord::Base

  include MisPerson

  AFFILIATIONS = ["staff","student","affiliate"]

  scoped_search :on => [:forename, :surname, :mis_id]

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
  has_many :support_requests
  has_many :support_strategies
  has_many :support_histories
  has_many :initial_reviews
  has_many :absences
  belongs_to :tutor, :class_name => "Person", :foreign_key => "tutor_id"
  
  serialize :middle_names
  serialize :address

  def age
    ((Date.today - date_of_birth.to_date)/365.25).to_i
  end

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
    (fresh ? import(mis_id) : find_by_mis_id(mis_id)) or import(mis_id)
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

  def as_param
    {:person_id => mis_id.to_s}
  end

  def method_missing(m, *args, &block)
    m = m.to_s
    if /^#{AFFILIATIONS.join"|"}\?$/.match m
      return Person.affiliation == m.chop
    else
      super
    end
  end


end
