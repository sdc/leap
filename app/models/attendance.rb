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
  default_scope { order('week_beginning') }

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

  def siblings_same_year(course_type = "overall")
    course_type = course_type.to_s
    d, m = Settings.year_boundary_date.split("/").map(&:to_i)
    bty = week_beginning.change(month: m, day: d)
    if bty > week_beginning
      return Attendance.where(course_type: course_type, person_id: person_id, week_beginning: bty.change(year: bty.year - 1)..bty).
        where("week_beginning <= ?",week_beginning)
    else
      return Attendance.where(course_type: course_type, person_id: person_id, week_beginning: bty..bty.change(year: bty.year + 1)).
        where("week_beginning <= ?",week_beginning)
    end
  end

  def cats_same_date
    Attendance.where(week_beginning: week_beginning, person_id: person_id)
  end

  def timeline_attrs
    series = ["Overall"] + Category.first(3).map(&:title)
    {
      colors: ["#fff"] + Category.first(3).map(&:color),
      final: person.attendance,
      data: {
        series: series,
        data: siblings_same_year.map{|a| {x: a.week_beginning.strftime('%d %m'), y: a.cats_same_date.map(&:att_year), tooltip: a.week_beginning.strftime("%d %m %y")}}
        #data: siblings_same_year.map{|a| {x: a.week_beginning.strftime('%d %m'), y: a.att_year, tooltip: "#{a.att_year}%"}}
      }
    }
  end

  def timeline_template
    "attendance"
  end

end
