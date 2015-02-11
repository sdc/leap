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

class TimetablesController < ApplicationController
  before_filter :set_date
  layout :set_layout

  def index
    @date = @date.to_date.at_beginning_of_week
    @end_date = @date.next_week
    if params[:year]
      (d, m) = Settings.year_boundary_date.split("/").map{ |x| x.to_i }
      ab = @date.change(day: d, month: m)
      if ab < @date
        @date = ab
        @end_date = ab + 1.year
      else
        @end_date = ab
        @date = ab - 1.year
      end
    end
    @registers = @topic.timetable_events(from: @date, to: @end_date)
    @view = View.for_user.find_by_name("timetable")
    @events = if @topic.kind_of? Person
      @topic.events.where(event_date: (@date.to_time + 1.hour + 1.second)..@end_date, transition: @view.transitions, eventable_type: @view.events)
    else
      []
    end
    respond_to do |format|
      format.html { render action: Settings.home_page == "new" ? :cloud_index : :index }
      format.xml { render xml: @topic }
      format.ics do
        cal = Icalendar::Calendar.new
        @registers.each { |r| cal.add_event(r.to_ics) }
        render text: cal.to_ical
      end
    end
  end

  def set_layout
    return "application" unless @topic.kind_of?(Person)
    Settings.home_page == "new" ? "cloud" : "application"
  end
end
