class TargetsController < ApplicationController

  def update
    @target = @topic.targets.find(params[:id])
    @event = Event.find(params[:event_id])
    @events = @target.events
    @target.update_attributes(params[:target])
    if params[:commit] == "Complete"
      @target.notify_complete
    end
    render @event
  end

end
