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

class ContinuingLearning < ActiveRecord::Base

  attr_accessible :person_code, :leap_person_id, :dept, :section, :course_code, :uio_id, :course_desc, :group, :answer_desc, :answer_colour, :answer_cat

  validates :person_code,    :presence => true
  validates :leap_person_id, :presence => true

  has_one :person, :foreign_key => "id"

  def self.category_icons
    cl_icons = {}
    Settings.continuing_learning_icons.split("|").each{|x| b=x.split(';'); cl_icons[b.first] = b.last}
    return cl_icons
  end

  def self.mapped_colours
    cl_colours = {}
    Settings.continuing_learning_colours.split("|").each{|x| b=x.split(';'); cl_colours[b.first] = b.last}
    return cl_colours
  end

end
