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

class Attendance < Eventable

  default_scope :order => 'week_beginning'

  after_create do |attendance|
    attendance.events.create!(:event_date => week_beginning.end_of_week, :transition => :complete)
  end

  def title
    if (week_beginning.end_of_week).future?
      "Attendance so far this week"
    else
      "Attendance"
    end
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

  def siblings_same_year
    d,m = Settings.year_boundary_date.split("/").map{|x| x.to_i}
    bty = week_beginning.change(:month => m, :day => d)
    if bty > week_beginning
      return Attendance.where(:person_id => person_id, :week_beginning => bty.change(:year => bty.year - 1)..bty)
    else
      return Attendance.where(:person_id => person_id, :week_beginning => bty..bty.change(:year => bty.year + 1))
    end
  end

end
