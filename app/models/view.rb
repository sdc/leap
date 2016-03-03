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

class View < ActiveRecord::Base

  serialize :transitions
  serialize :events
  serialize :affiliations
  serialize :controls

  validates :transitions, :presence => true
  validates :events, :presence => true
  validates :affiliations, :presence => true
  validates :name, :presence => true

  belongs_to :parent, :class_name => "View"
  has_many   :children, :class_name => "View", :foreign_key => "parent_id"

  scope :for_user,    lambda { where('affiliations like ?', "%#{Person.affiliation}%")}
  scope :in_list, -> { where(:in_list => true) }
  scope :top_level, -> { where("parent_id is null") }

  def to_param
    name
  end

  def long_name
    "#{label}: #{affiliations.join ", "}"
  end

end
