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

class Attendance < Eventable

  default_scope :order => 'week_beginning'

  after_create do |attendance|
    attendance.events.create!(:event_date => week_beginning, :transition => :complete)
  end

  def title
    "Weekly Attendance"
  end

  def status
    if att_year > 89
      :complete
    elsif att_year > 84
      :start
    else
      :overdue
    end
  end

  def subtitle
    "#{att_year}%"
  end

end
