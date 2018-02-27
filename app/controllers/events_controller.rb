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
        flash[:success] = "New #{et.singularize.humanize.titleize} created"
      else
        logger.error "*" * 1000
        @event.errors.each do |c,e|
          logger.error c.to_s + " -- " + e
        end
        flash[:error] = "#{et.singularize.humanize.titleize} could not be created!"
        flash[:details] = @event.errors.map{|c,e| "<b>#{c}:</b> #{e}"}.join "<br />"
      end
      if view = params[:redirect_to] 
        redirect_to params[:redirect_to]
      else
        begin
          render @event 
        rescue
          redirect_to :back
        end
      end
    else
      redirect_to "/404.html"
    end
  end

  def update
    @event = @topic.events.find(params[:id])
    et = @event.eventable_type.tableize
    if @affiliation == "staff" or Settings.students_update_events.split(",").include? et
      if @event.eventable.update_attributes(params[et.singularize])
        flash[:success] = "#{@event.eventable_type.humanize} updated"
      else
        flash[:error] = "#{@event.eventable_type.humanize} could not be updated!"
      end
      respond_to do |f|
        f.js   {render @event}
        f.html {redirect_to :back}
      end
    else
      redirect_to "/404.html"
    end
  end

  def destroy
    if @affiliation == "staff"
      @event = Event.find(params[:id])
    else
      @event = @topic.events.find(params[:id])
    end
    if @event.is_deletable?
      flash[:success] = "#{@event.eventable_type.singularize.humanize.titleize} deleted"
      binding.pry
      @event.eventable.destroy
    else
      flash[:error] = "#{@event.eventable_type.singularize.humanize.titleize} could not be deleted"
    end
    respond_to do |f|
      f.html {redirect_to :back}
      f.js 
    end
  end
end
