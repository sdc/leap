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

class LsfBursaryFund < ActiveRecord::Base

  # attr_accessible :mis_id, :person_id, :fund, :support_category, :support_type, :year

  validates :mis_id,      :presence => true
  validates :person_id,      :presence => true

  belongs_to :person

  # scope :this_year, lambda {where("event_date > ?",year_start)}
  # default_scope order("id DESC")

end
