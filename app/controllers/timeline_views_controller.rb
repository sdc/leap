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
    render json: TimelineView.where.not("admin_only").as_json
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
    events = scope.where.any_of(*(view.events.map{|etype,trans| {eventable_type: etype}.merge(trans ? {transition: trans} : {})}))
    render json: events
  end
end
