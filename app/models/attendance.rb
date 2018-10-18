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

require 'misc/misc_dates'

class Attendance < Eventable

  attr_accessible :week_beginning, :att_year, :att_week, :course_type

  default_scope { order(:week_beginning) }

  after_create do |attendance|
    attendance.events.create!(:event_date => week_beginning.end_of_week, :transition => :complete) if attendance.course_type == "overall"
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
      Attendance.get_status(att_year, bs)
    end
  end

  def status_6week(bs = false)
    begin
      Attendance.get_status(att_6_week, bs)
    end
  end

  def subtitle
    "#{att_year}%"
  end

  def siblings_same_year(course_type = "overall", enrol_course = nil)
    d,m = Settings.year_boundary_date.split("/").map{|x| x.to_i}
    bty = week_beginning.change(:month => m, :day => d)

    return Attendance.where(:course_type => course_type.to_s, :person_id => person_id, :week_beginning => bty.change(:year => bty.year - 1)..bty) if course_type.present? && bty > week_beginning
    return Attendance.where(:course_type => course_type.to_s, :person_id => person_id, :week_beginning => bty..bty.change(:year => bty.year + 1)) if course_type.present?
    return Attendance.where(:enrol_course => enrol_course.to_s, :person_id => person_id, :week_beginning => bty.change(:year => bty.year - 1)..bty) if enrol_course.present? && bty > week_beginning
    return Attendance.where(:enrol_course => enrol_course.to_s, :person_id => person_id, :week_beginning => bty..bty.change(:year => bty.year + 1)) if enrol_course.present?
  end

  def to_tile
    Tile.new(tile_attrs)
  end

  def bg
    begin
      bg = if att_year < Settings.attendance_low_score.to_i
        "a66"
      elsif att_year < Settings.attendance_high_score.to_i
        "da6"
      elsif ( !Settings.attendance_exceed_score.nil? && att_year >= Settings.attendance_exceed_score.to_i )
        "64a; color: white"
      else
        "6a6"
      end
    rescue
      bg = "6a6"
    end
  end

  def att_6_week
    begin
      # arr = Attendance.where( :person_id=> person_id, :course_type => course_type, week_beginning: 6.weeks.ago..Date.today  ).all.collect(&:att_week).compact if course_type.present?
      # arr = Attendance.where( :person_id=> person_id, :enrol_course => enrol_course, week_beginning: 6.weeks.ago..Date.today  ).all.collect(&:att_week).compact if enrol_course.present?
      arr = siblings_same_year(course_type, enrol_course).where( week_beginning: 6.weeks.ago..Date.today  ).to_a.collect(&:att_week).compact
      return ( arr.map{|x| x.to_i}.sum / arr.length ) if arr.present? and arr.length > 0
    end
  end

  def bg_6_week
    begin
      bg = if att_6_week < Settings.attendance_low_score.to_i
        "a66"
      elsif att_6_week < Settings.attendance_high_score.to_i
        "da6"
      elsif ( !Settings.attendance_exceed_score.nil? && att_6_week >= Settings.attendance_exceed_score.to_i )
        "64a; color: white"
      else
        "6a6"
      end
    rescue
      bg = "a66"
    end
  end

  def tile_attrs
    begin
      bg = if att_year < Settings.attendance_low_score.to_i
        "a66"
      elsif att_year < Settings.attendance_high_score.to_i
        "da6"
      elsif ( !Settings.attendance_exceed_score.nil? && att_year >= Settings.attendance_exceed_score.to_i )
        "64a; color: white"
      else
        "6a6"
      end
    rescue
      bg = "6a6"
    end
    acy = MISC::MiscDates.acyr(week_beginning)
    {:icon         => "fa-check-circle",
     :partial_path => "tiles/attendance",
     :subtitle     => course_type.titlecase,
     :bg           => bg,
     :title        => "Attendance"+" "+acy,
     :object       => self
    }
  end

  def icon_class
    "fa-clipboard"
  end

  def self.get_status(att_value = nil, bs = false)
    begin
      if att_value < Settings.attendance_low_score.to_i
        bs ? :danger : :overdue
      elsif att_value < Settings.attendance_high_score.to_i
        bs ? :warning : :start
      elsif ( !Settings.attendance_exceed_score.nil? && att_value >= Settings.attendance_exceed_score.to_i )
        bs ? :exceed : :exceed
      else
        bs ? :success : :complete
      end
    rescue
      :default
    end
  end

end
