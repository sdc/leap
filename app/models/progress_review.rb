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

class ProgressReview < Eventable
  attr_accessible :attendance, :body, :completed_by, :completed_date, :id, :level, :number, :progress_id, :working_at

  belongs_to :progresses, :foreign_key => "progress_id"
  before_save :set_values

  after_create do |line|
    line.events.create!(:event_date => completed_date, :transition => :create)
  end

  def set_values
  	self.id ||= progress_id + '_' + number.to_s
  	self.completed_date ||= Time.now
  	self.created_by_id ||= Person.user.id
  end

end
