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

class Ebs::RegisterEventDetailsSlot < Ebs::Model
  
  belongs_to :register_event
  belongs_to :register_event_slot
  delegate   :description, :to => :register_event
  delegate   :rooms, :teachers, :to => :register_event_slot

  def the_object
    case object_type 
    when "R" then Ebs::Room.find_by_id(object_id)
    when "T" then Ebs::Person.find(object_id)
    when "L" then Ebs::Person.find(object_id)
    else throw "Not a known object"
    end
  end

  def usage
    Ebs::Usage.find_by_usage_code_and_object_type(usage_code,object_type)
  end

  def status
    return "unknown" unless usage
    case usage.positive_for_ema
    when "Y" then "complete"
    when "N" then "incomplete"
    else "unknown"
    end
  end

end
