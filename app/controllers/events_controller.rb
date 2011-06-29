class EventsController < ApplicationController

  before_filter :set_scope, :only => [:index]

  def index
    @date = get_date + 1.day
    conds = {}
    conds[:eventable_type] = params[:eventable_type].keys if params[:eventable_type]
    conds[:transition] = params[:transition].keys if params[:transition]
    @events =
      @scope.where("event_date <= ?", @date).
      where(conds).
      order("event_date DESC")
      #includes(:eventable).
      #includes(:children => [:eventable])
    @bottom_date = @events.last.event_date unless @events.empty?
    respond_to do |f|
      f.html
      f.xml  { render :xml  => @events.to_xml( :include => :eventable) }
      f.json { render :json => @events.to_json(:include => :eventable) }
    end
  end

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

  private

  def get_date
    if params[:date]
      if params[:date].kind_of? Hash
        Time.gm(*[:year,:month,:day].map{|x| params[:date][x].to_i})
      else
        Time.parse(params[:date])
      end
    else
      Time.now.midnight + 2.years
    end
  end

  def set_scope
    @scope = if (@affiliation == "staff" and params[:all])
      @multi = true
      Event.scoped
    else
      @multi = false
      @topic.events
    end
  end

end
