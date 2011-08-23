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

class Ebs::Address < Ebs::Model

  set_primary_key "per_person_code"  
  set_table_name "student_addresses"

  belongs_to :person,  :foreign_key => "per_person_code"

  def postcode
    (uk_post_code_pt1 || "") + " " + (uk_post_code_pt2 || "")
  end

end
