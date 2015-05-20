# Leap - Electronic Individual Learning Plan Software
# Copyright (C) 2015 South Devon College

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

class TimelineViewsController < ApplicationController
  def index
    views = TimelineView.where("aff_#{Person.affiliation}"  => true,
                               "topic_#{@topic.topic_type}" => true)
    render json: views
  end

  def show
    view = TimelineView.where("url" => params[:id],
                              "aff_#{Person.affiliation}"  => true,
                              "topic_#{@topic.topic_type}" => true).first
    scope = if Person.user.staff? && params[:all]
      Event.all
    elsif Person.user.staff? && @topic.kind_of?(Course)
      #if @tutorgroup
      #  Event.where(:person_id => @topic.person_courses.where(:tutorgroup => @tutorgroup).map{|p| p.person_id})
      #else
        Event.where(person_id: @topic.people.map(&:id))
      #end
    else
      @topic.events
    end
    date = params[:date] ? Date.parse(params[:date]) : Date.today()
    scope = if view.view_type == "timetable"
              scope.where(event_date: date.beginning_of_week...date.end_of_week)
            else
              scope.where("event_date > ?", date)
            end
    conds = []
    str = []
    view.events.each do |etype,trans|
      if trans
        str.unshift "(eventable_type = ? and transition in (?))"
        conds.unshift etype,trans
      else
        str.unshift "(eventable_type = ?)"
        conds.unshift etype
      end
    end
    events = scope.where(str.join(" or "), *conds)
    render json: {view: view, events: events}
  end
end
