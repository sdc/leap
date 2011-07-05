class EventsController < ApplicationController

  def open_extended
    @event = @topic.events.find(params[:id])
    render :partial => "extended", :object => @event, :as => :event
  end

  def show
    @event = @topic.events.find(params[:id])
    render @event
  end

  def new
    render :partial => "#{params[:eventable_type].tableize}/new"
  end

  def create
    et = params[:event].delete(:eventable_type).tableize
    @topic.send(et).create(params[:event])
    redirect_to person_events_url(@topic)
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to :back
  end

end
