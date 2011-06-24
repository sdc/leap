class TargetsController < ApplicationController

  def create
    @event = Event.find(params[:target][:event_id])
    @target = @event.targets.create(params[:target].merge(:person_id => @event.person_id, :set_by_person_id => @user.id))
    @events = [@event]
    render @event
  end

  def update
    @target = Target.find(params[:id])
    @event = Event.find(params[:event_id])
    @events = @target.events
    @target.update_attributes(params[:target])
    if params[:commit] == "Complete"
      @target.notify_complete
    end
    render @event
  end

end
