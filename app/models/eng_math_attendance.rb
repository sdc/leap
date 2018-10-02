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

require 'misc/misc_dates'

class EngMathAttendance < Eventable

  self.table_name = "eng_math_attendance"

  default_scope { order('year DESC') }

  def status(bs = false)
    begin
      last_three_att =~ /(^[\/]{1,3})/
      if $~[0].present?
        :danger
      end
      last_three_att =~ /([^\/])/
      if $~[0].present?
        :warning
      end
      last_three_att =~ /(^[O]{1,3})/
      if $~[0].present?
        :success
      end
    rescue
      :default
    end
  end

  def bg
    begin
      last_three_att =~ /(^[\/]{1,3})/
      if $~[0].present?
        bg = "64a"
      end
      last_three_att =~ /([^\/])/
      if $~[0].present?
        bg = "da6"
      end
      last_three_att =~ /(^[O]{1,3})/
      if $~[0].present?
        bg = "a66"
      end
    rescue
      bg = "6a6"
    end
  end

end
