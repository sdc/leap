class TargetsController < ApplicationController

  def new
    @event = Event.find(params[:event_id])
  end

  def create
    @event = Event.find(params[:target][:event_id])
    @target = @event.targets.create(params[:target].merge(:person_id => @event.person_id))
  end

end
