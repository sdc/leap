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

class Attendance < Eventable
  default_scope order: 'week_beginning'

  after_create do |attendance|
    attendance.events.create!(event_date: week_beginning.end_of_week, transition: :complete) if attendance.course_type == "overall"
  end

  def title
    if (week_beginning.end_of_week).future?
      "Attendance so far this week"
    else
      "Attendance"
    end
  end

  def status(bs = false)
    begin
      if att_year < Settings.attendance_low_score.to_i
        bs ? :danger : :overdue
      elsif att_year < Settings.attendance_high_score.to_i
        bs ? :warning : :start
      else
        bs ? :success : :complete
      end
    rescue
      :default
    end
  end

  def subtitle
    "#{att_year}%"
  end

  def siblings_same_year(course_type = "overall")
    course_type = course_type.to_s
    d,m = Settings.year_boundary_date.split("/").map{ |x| x.to_i }
    bty = week_beginning.change(month: m, day: d)
    if bty > week_beginning
      return Attendance.where(course_type: course_type, person_id: person_id, week_beginning: bty.change(year: bty.year - 1)..bty)
    else
      return Attendance.where(course_type: course_type, person_id: person_id, week_beginning: bty..bty.change(year: bty.year + 1))
    end
  end

  def to_tile
    Tile.new(tile_attrs)
  end

  def tile_attrs
    begin
      bg = if att_year < Settings.attendance_low_score.to_i
        "a66"
      elsif att_year < Settings.attendance_high_score.to_i
        "da6"
      else
        "6a6"
      end
    rescue
      bg = "6a6"
    end
    {icon: "fa-check-circle",
     partial_path: "tiles/attendance",
     subtitle: course_type.titlecase,
     bg: bg,
     title: "Attendance", 
     object: self
    }
  end
end
