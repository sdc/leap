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

class Qualification < Eventable

  include MisQualification

  after_create {|qual| qual.events.create!(:event_date => created_at, :transition => qual.predicted? ? :create : :complete)}

  before_save  {|q| q.predicted=true if (Person.user and !Person.user.staff?)}

  validates :title, :presence => true 
  
  attr_accessible :awarding_body, :grade, :predicted, :qual_type, :seen, :title, :created_at

  def body
    [self[:qual_type],self[:title]].reject{|x| x.blank?}.join ": "
  end

  def subtitle
    grade
  end

  def status
    predicted ? :not_started: (seen ? :complete : :current)
  end

  def title
    predicted ? ["Predicted","Grade"] : (seen ? "Qualification" : ["Qualification","(not seen)"])
  end

  def seen
    self[:seen] or mis_id
  end

end
