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

class Ebs::PeopleUnit < Ebs::Model

  belongs_to :person, :foreign_key => "person_code"
  belongs_to :unit_instance_occurrence , :foreign_key => "uio_id"
  has_one    :people_unit_special, :foreign_key => "people_units_id"
  has_many   :people_unit_tutorgroups, :foreign_key => "people_units_id"
  has_many   :tutorgroups, :through => :people_unit_tutorgroups
  belongs_to :code, :foreign_key => "progress_code", :class_name => "ProgressCode"
  self.primary_key= :id

  def status
    code.try(:fes_short_description)
  end

  def tutorgroup
    tutorgroups.last.try :name
  end

end
