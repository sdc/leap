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

class Absence < Eventable

  attr_accessible :lessons_missed, :category, :body, :usage_code, :contact_category

  after_create {|ab| ab.events.create!(:event_date => created_at, :transition => :create)}

  def subtitle
    usage_code
  end

  def status
    Ilp2::Application.config.mis_usage_codes[usage_code]
  end

end
