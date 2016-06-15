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
  attr_accessible :attendance, :body, :completed_by, :created_at, :id, :level, :number, :progress_id, :working_at

  belongs_to :progress, :foreign_key => "progress_id"
  before_save :set_values

  after_create do |line|
    line.events.create!(:event_date => created_at, :transition => :create, :person_id => person_id)
  end

  def set_values
  	self.created_at ||= Time.now
  	self.created_by_id ||= Person.user.id
  end

  def status
    begin
      if self.level == 'purple'
        return :outstanding
      elsif self.level == 'green'
        return :complete
      elsif self.level == 'amber'
        return :current
      elsif self.level == 'red'
        return :incomplete
      end
    end
  end

end
