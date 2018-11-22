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

class TtActivity < Eventable

  REPEAT_TYPES = ["No repeat","Weekly","Monthly"]

  TIME_SELECT = (0..600).step(15).map{|x| ["#{x.divmod(60).join(" hours ")} mins",x*60]}.drop 1

  before_save :fix_start_time

  def strong_params_validate
    params = []
    self.repeat_number = 1 if self.repeat_type == "No repeat"
    this_start = self.start_time
    1.upto(self.repeat_number) do |i|
      params.push(:event_date => this_start, :transition => :start)
      this_start = case self.repeat_type.downcase
      when "weekly" then this_start + 1.week
      when "monthly" then this_start + 1.month
      else this_start
      end
    end   
    return params
  end

  def title; category end

  def fix_start_time
    self.start_time = Time.new(self.tmp_date.year, tmp_date.month, tmp_date.day,
	                      self.tmp_time.hour, self.tmp_time.min)
  end

  def status
    return "start"
  end

  def timetable_length
    self[:timetable_length]
  end

end
