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

class View < ActiveRecord::Base

  serialize :transitions
  serialize :events
  serialize :affiliations
  serialize :controls

  scope :affiliation, lambda {|aff| {:conditions => ["affiliations like ?", "%#{aff}%"]}}
  scope :in_list, where(:in_list => true)

  def to_param
    name
  end

end
