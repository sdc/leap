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

class ViewsController < ApplicationController

  respond_to :html, :xml, :js, :pdf, :json

  before_action :set_scope
  before_action { |c| c.set_date(1.year) }

  def show
    if @view = View.for_user.find_by_name(params[:id])
      @subviews = @view.parent_id ? @view.parent.try(:children) : @view.children
      if params[:filter]
        @events =
          @scope.joins("INNER JOIN interventions ON events.eventable_id = interventions.id").
          where("interventions.pi_type = ?", params[:pi_type]).
          where("interventions.referral_text LIKE (?)", "%#{params[:int_text]}%").
          where("event_date < ?", @date).
          where(:transition => @view.transitions, :eventable_type => @view.events).
          limit(request.format=="pdf" ? 20000 : 20)
        @events = @events.where("interventions.referral_category = ?", params[:pint_category]) unless params[:pint_category] == 'All';
      else
        @events =
          @scope.where("event_date < ?", @date).
          where(:transition => @view.transitions, :eventable_type => @view.events).
          limit( (request.format=="pdf" ? 20000 : (request.format=="json" ? 2000 : 20)) )
      end
      if Settings.home_page == "progress"
        @notifiedEvents = @events.joins(:notifications).where(:notifications => {:notified => false, :person_id => @user.id})
        @notifiedEvents.each do |notifiedEvent|
          notifiedEvent.notifications.each do |notification|
            notification.notified = true
            notification.save
          end
        end
      end
      @events = @events.select{|e| e.status.to_s == params[:status]} if params[:status]
      @events = @events.select{|e| e.title.to_s == params[:title]} if params[:title]
      @events.detect{|e| e.past? }.try("first_in_past=",true) unless @events.first.past? if @events.try(:first)
      # @events.reject!{|e| e.staff_only?} unless @user.staff?
      @events.reject{|e| e.staff_only?} unless @user.staff?
      # @events.reject!{|e| e.is_deleted?}
      @events.reject{|e| e.is_deleted?}
      respond_with(@events) do |f|
        f.js {render @events}
      end
    else
      redirect_to "/404.html"
    end
  end
  
  def header
    @view = View.for_user.find_by_name(params[:id])
  end

  private

  def set_scope
    @scope = if (@affiliation == "staff" and params[:all])
      @multi = true
      # Event.scoped
      Event.all
    elsif (@affiliation == "staff" and @topic.kind_of? Course)
      @multi = true
      if @tutorgroup
        Event.where(:person_id => @topic.person_courses.where(:tutorgroup => @tutorgroup).map{|p| p.person_id})
      else
        Event.where(:person_id => @topic.people.map{|p| p.id})
      end
    else
      @multi = false
      @topic.events
    end
  end
end
