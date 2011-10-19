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

module MisPerson

  def self.included receiver
    receiver.extend ClassMethods
  end

  module ClassMethods

    def connector
      "No connector"
    end

    def import(mis_id)
      return Person.find_by_mis_id(mis_id) || false
    end
  end

  def photo_path
    return "/images/noone.png"
  end

  def import_courses
      return Person.find_by_mis_id(mis_id) || false
  end
  
  def timetable_events(*junk)
    return []
  end

end

module MisCourse

  def self.included receiver
    receiver.extend ClassMethods
  end

  module ClassMethods
    def import(mis_id)
      return Course.find_by_mis_id(mis_id) || false
    end
  end

end

module MisQualification
end

module MisPersonCourse
end
