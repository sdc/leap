class EventsController < ApplicationController

  def index
    @events = Event.includes(:eventable).order("event_date DESC").map{|event| event.eventable}
  end

end
