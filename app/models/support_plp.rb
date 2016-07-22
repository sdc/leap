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

class SupportPlp < ActiveRecord::Base

  attr_accessible :name, :value, :description, :end_date, :start_date, :active, :domain, :source, :created_at, :deleted

  validates :person_id,      :presence => true
  validates :name,      :presence => true

  belongs_to :person
  belongs_to :created_by, :class_name => "Person", :foreign_key => "created_by_id"

  scope :this_year, lambda {where("event_date > ?",year_start)}
  default_scope order("id DESC")

  before_create do |sp| 
    sp.created_at = DateTime.now unless sp.created_at
    sp.created_by_id = Person.user ? Person.user.id : nil unless sp.created_by_id
  end

end
