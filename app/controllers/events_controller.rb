class EventsController < ApplicationController

  before_filter :parse_id
  before_filter :set_event_scope

  def index
    @date = get_date + 1.day
    conds = {:event_date => (@date - 2.week)..@date}
    conds[:eventable_type] = params[:eventable_type].keys if params[:eventable_type]
    @events = @scope.
      where(conds).
      order("event_date DESC").
      includes(:eventable)
    render @events if request.xhr?
  end

   def open_extended
    @event = @scope.find(params[:id])
    render :partial => "extended", :object => @event, :as => :event
  end

  def show
    @event = @scope.find(params[:id])
    render @event
  end

  private

  def get_date
    if params[:date]
      if params[:date].kind_of? Hash
        Time.gm(*[:year,:month,:day].map{|x| params[:date][x].to_i})
      else
        Time.parse(params[:date])
      end
    else
      Time.now.midnight
    end

  end

  def parse_id
    params[:id].sub!(/^event_/,"") if params[:id]
  end

  def set_event_scope
    if params[:person_id]
      @scope = Person.get(params[:person_id]).events
    else
      @scope = Event
    end
  end

end
