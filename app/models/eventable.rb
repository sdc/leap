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

class Eventable < ActiveRecord::Base

  self.abstract_class = true

  belongs_to :person
  belongs_to :created_by, :foreign_key => "created_by_id", :class_name => "Person"
  has_many :events, :as => :eventable, :dependent => :destroy

  before_validation {|e| update_attribute("created_by_id", Person.user ? Person.user.id : nil) unless e.created_by_id}

  validates :person_id, :presence => true

  def icon_url
    "events/#{self.class.name.tableize}.png"
  end

  def title
    self.class.name.underscore.humanize.titleize
  end

end
