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
  before_action :set_scope
  def open_extended
    @event = @topic.events.find(params[:id])
    render partial: "extended", object: @event, as: :event
  end

  def show
    @event = @scope.find(params[:id])
    render json: @event.as_timeline_event
  end

  def create
    params.require(:eventable_type)
    et = params.delete(:eventable_type).tableize
    category = Category.find(params[et.singularize].delete(:category_id)) if params[et.singularize][:category_id]
    if @affiliation == "staff" || Settings.students_create_events.split(",").include?(et)
      params.require(et.singularize).permit!
      @event = @topic.send(et).build(params[et.singularize])
      if @event.save
        @event.events.each{|e| e.update_attribute "category_id", category.id } if category
        render json: @event
      else
        render json: { errors: @event.errors.full_messages }
      end
    else
      redirect_to "/404.html"
    end
  end

  def update
    @event = @topic.events.find(params[:id])
    et = @event.eventable_type.tableize
    if @affiliation == "staff" || Settings.students_update_events.split(",").include?(et)
      if @event.eventable.update_attributes(params[et.singularize])
        flash[:success] = "#{@event.eventable_type.humanize} updated"
      else
        flash[:error] = "#{@event.eventable_type.humanize} could not be updated!"
      end
      respond_to do |f|
        f.js   { render @event }
        f.html { redirect_to :back }
      end
    else
      redirect_to "/404.html"
    end
  end

  def destroy
    @event = @topic.events.find(params[:id])
    if @event.is_deletable?
      flash[:success] = "#{@event.eventable_type.singularize.humanize.titleize} deleted"
      @event.eventable.destroy
    else
      flash[:error] = "#{@event.eventable_type.singularize.humanize.titleize} could not be deleted"
    end
    respond_to do |f|
      f.html { redirect_to :back }
      f.js   { render json: @event }
    end
  end

  def set_scope
    @scope = if @affiliation == "staff" && params[:all]
               @multi = true
               Event.limit(100)
             elsif @affiliation == "staff" && @topic.kind_of?(Course)
               @multi = true
               if @tutorgroup
                 Event.where(person_id: @topic.person_courses.where(tutorgroup: @tutorgroup).map(&:person_id))
               else
                 Event.where(person_id: @topic.people.map(&:id))
               end
             else
               @multi = false
               @topic.events
             end
  end
end
