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

class Ebs::Person < Ebs::Model

  # self.primary_key= :person_code
  self.primary_key= :person_code

  #default_scope where("date_of_birth is not null")#.where("fes_user_25 = 1")

  scoped_search :on => [:forename, :surname, :person_code]

  belongs_to :note, :foreign_key => "notes"
  has_many :targets
  has_many :learner_aims,
           :foreign_key => "person_code"
  has_one  :address, 
           :foreign_key => "owner_ref",
           :conditions  => ["end_date IS NULL"]
  has_many :people_units,
           :foreign_key => "person_code"
  has_many :unit_instance_occurrences, 
           :through => :people_units
  has_many :attendances,
           :foreign_key => "person_code"
  has_many :attainments,
           :foreign_key => "per_person_code"
  belongs_to :tutor, :class_name => "Person", :foreign_key => "student_staff_tutor"
  has_many :blobs, :foreign_key => "owner_ref"

  def name
    [forename,surname].join(" ")
  end

  def address
    Ebs::Address.where(:owner_ref => "#{id}").where("end_date IS NULL").last
  end

end
