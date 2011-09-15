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

  respond_to :html, :xml, :js

  before_filter :set_scope
  before_filter { |c| c.set_date(1.year) }

  def show
    if @view = View.for_user.find_by_name(params[:id])
      @events =
        @scope.where("event_date < ?", @date).
        where(:transition => @view.transitions, :eventable_type => @view.events).
        limit(20)
      @events.detect{|e| e.past? }.first_in_past= true unless @events.first.past? if @events.first
      @bottom_date = @events.last.try(:event_date)
      respond_with @events do |f|
        f.js { render @events }
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
