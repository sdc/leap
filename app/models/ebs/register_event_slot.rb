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

class Ebs::RegisterEventSlot < Ebs::Model

  set_table_name "register_event_slots"

  belongs_to :register_event
  has_many   :register_event_details_slots

  def rooms
    register_event_details_slots.where(:object_type => "R").map{|d| d.the_object}
  end

  def teachers
    register_event_details_slots.where(:object_type => "T").map{|d| d.the_object}
  end

  def learners
    register_event_details_slots.where(:object_type => "L").map{|d| d.the_object}
  end

end
