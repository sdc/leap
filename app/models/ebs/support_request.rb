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

class Ebs::SupportRequest < Ebs::Model

  set_table_name "sdc_ilp_support_requests"

  belongs_to :person
  serialize :register_events
  serialize :difficulty

   #def res
   #  register_events ? register_events.map{|reid| RegisterEvent.find_by_id(reid) or nil}.reject{|re| re.nil?}.map{|re| re.description} : []
   #end
   
   def res 
     begin
       register_events.map{|reid| Ebs::RegisterEvent.find(reid)}.map{|re| re.description}
     rescue
       []
     end
   end


end
