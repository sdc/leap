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

class EventsController < ApplicationController

  def open_extended
    @event = @topic.events.find(params[:id])
    render :partial => "extended", :object => @event, :as => :event
  end

  def show
    @event = @topic.events.find(params[:id])
  end

  def create
    et = params.delete(:eventable_type).tableize
    if @affiliation == "staff" or Settings.students_create_events.split(",").include? et
      @event = @topic.send(et).build(params[et.singularize])
      if @event.save
        flash[:notice] = "New #{et.singularize.humanize.titleize} created"
      else
        flash[:notice] = "#{et.singularize.humanize.titleize} could not be created!"
      end
      if view = params[:redirect_to] 
        redirect_to params[:redirect_to]
      else
        redirect_to :back
      end
    else
      redirect_to "/404.html"
    end
  end

end
