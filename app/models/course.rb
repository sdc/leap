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

class Course < ActiveRecord::Base

  include MisCourse

  attr_accessible :title, :code, :year, :mis_id, :vague_title

  has_many :person_courses, :conditions => "enrolment_date is not null"
  has_many :people, :through => :person_courses

  scoped_search :on => [:title,:code]

  def Course.get(mis_id,fresh=false)
    (fresh ? import(mis_id, :people => true) : find_by_mis_id(mis_id)) or import(mis_id, :people => true)
  end

  def other_years
    Course.where(:code => code).order(:year)
  end

  def name
    title.try(:titlecase) or code
  end

  def to_param
    mis_id.to_s
  end

  def as_param
    {:course_id => mis_id.to_s}
  end

  def mis_code
    code
  end

  def staff?
    false
  end

  def photo_uri
    "courses.png"
  end

  def tutorgroups
    groups = person_courses.group("tutorgroup").map{|pc| pc.tutorgroup}.reject{|g| g.blank?}
  end

  def entry_reqs
    return [] if vague_title.blank?
    EntryReq.where(:app_title => vague_title).group_by{|er| [er.app_title,er.course_title,er.course_qual]}
  end

  def person?; false end
  def course?; true end

end
