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

class TimetableEvent
  
  attr_accessor :title, :timetable_start, :timetable_end, :rooms, :teachers, :mark, :status, :mis_id

  def timetable_margin
   ((timetable_start - timetable_start.change(hour: 8,minute: 0, sec: 0, usec: 0)) / 50).floor
  end
 
  def timetable_height
    ((timetable_end - timetable_start) /50).floor
  end

  def subtitle; nil end
  def body; nil end
  def is_deletable?; false end
  def id; mis_id end

  def cl_status
    {"unknown"    => "default",
     "complete"   => "success",
     "current"    => "warning",
     "incomplete" => "danger"
    }[status]
  end

  def to_tile
    Tile.new({title: "Next Lesson",
              bg: "9aa",
              icon: "fa-calendar",
              partial_path: "tiles/next_lesson",
              object: self})
  end

  def to_ics
    e = Icalendar::Event.new
    e.dtstart = timetable_start.getutc
    e.dtend = timetable_end.getutc
    e.summary = "#{title} with #{teachers.join(", ")}"
    e.location = rooms.join(", ")
    return e
  end

end
