class EventsController < ApplicationController

  def index
    @events = Event.all(:include => :eventable).map{|event| event.eventable}
  end

end
