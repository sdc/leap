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

class Ebs::UnitInstanceOccurrence < Ebs::Model
  self.primary_key = :uio_id
  
  has_many :people_units, foreign_key: "uio_id"
  belongs_to :unit_instance, foreign_key: :fes_uins_instance_code

  delegate :fes_long_description, to: :unit_instance

  scoped_search on: [:fes_uins_instance_code, :long_description]

  def title
    long_description or fes_long_description
  end
end
