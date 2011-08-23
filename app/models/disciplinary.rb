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

class Disciplinary < Eventable

  validates :body, :presence => true
  validates :level, :presence => true, :numericality => true, :inclusion => {:in => -1..3}

  after_create {|disciplinary| disciplinary.events.create!(:event_date => created_at, :transition => :create)}

  # Returns the note eventable  Title. This is always the same.
  def title
    case level
      when -1 
        "Amber Alert Disciplinary"
      when 0
        "Amber Alert Pastorial"
      when 1
        "Positive Intervention Stage One"
      when 2
        "Positive Intervention Stage Two"
      when 3
        "Positive Intervention Stage Three"
    end
  end

end
