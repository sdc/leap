class ViewsController < ApplicationController

  before_filter :set_scope, :only => [:show]

  def show
    @view = View.find_by_name(params[:id])
    @date = get_date + 1.day
    @events, @future_events = 
      @scope.where("event_date <= ?", @date).
      where(:transition => @view.transitions, :eventable_type => @view.events).
      order("event_date DESC").
      partition {|e| e.event_date <= Time.now}
    @bottom_line = @events.last.event_date unless @events.empty?
  end

end
