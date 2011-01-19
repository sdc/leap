class TargetsController < ApplicationController

  def new
    @event = Event.find(params[:event_id])
  end

  def create
    @event = Event.find(params[:target][:event_id])
    @target = @event.targets.create(params[:target].merge(:person_id => @event.person_id))
    @events = [@event]
    render :refresh_extended
  end

  def update
    @target = Target.find(params[:id])
    @events = @target.events
    @target.update_attributes(params[:target])
    if params[:commit] == "Complete"
      @target.notify_complete(@target.complete_date)
    end
    render :refresh_extended
  end

end
