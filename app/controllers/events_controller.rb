class EventsController < ApplicationController

  before_filter :set_event_scope

  def index
    @date = get_date + 1.day
    @since = (Time.parse(params[:since]) + 1) if params[:since]
    @events = @scope.from_to(@since||@date - 2.week,@date).backwards.includes(:eventable)
  end

   def open_extended
    @event = @scope.find(params[:id])
    render :partial => "extended", :object => @event, :as => :event
  end


  private

  def get_date
    params[:date] ? Time.gm(*[:year,:month,:day].map{|x| params[:date][x].to_i}) : Time.now.midnight
  end

  def set_event_scope
    if params[:person_id]
      @scope = Person.get(params[:person_id]).events
    else
      @scope = Event
    end
  end

end
