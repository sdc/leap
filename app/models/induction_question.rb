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

class InductionQuestion < Eventable

  # after_create {|q| q.events.create!(:event_date => created_at, :transition => :create)}

  def strong_params_validate
  	[{:event_date => self.created_at, :transition => :create}]
  end  

  validates :question, :presence => true
  validates :question, :inclusion => {:in => Settings.induction_questions.split(";")}

  def icon_class
  	"fa-question-circle-o"
  end

  def accessible_attributes
    return ['question', 'answer']
  end  
end
