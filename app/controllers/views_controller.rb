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

class ViewsController < ApplicationController

  before_filter :set_scope, :only => [:show]

  def show
    if @view = View.affiliation(@affiliation).find_by_name(params[:id])
      @date = get_date
      @events, @future_events = 
        @scope.where("event_date < ?", @date).
        where(:transition => @view.transitions, :eventable_type => @view.events).
        order("event_date DESC").
        limit(20).
        partition {|e| e.event_date <= Time.now}
      @bottom_date = @events.last.event_date unless @events.empty?
      respond_to do |f|
        f.html
        f.xml { render :xml  => @events.to_xml (:include => :eventable)}
        f.json{ render :json => @events.to_json(:include => :eventable)}
      end
    else
      redirect_to "/404.html"
    end
  end

  private

  def set_scope
    @scope = if (@affiliation == "staff" and params[:all])
      @multi = true
      Event.scoped
    elsif (@affiliation == "staff" and @topic.kind_of? Course)
      @multi = true
      Event.where(:person_id => @topic.people.map{|p| p.id})
    else
      @multi = false
      @topic.events
    end
  end

end
