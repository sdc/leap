class EventsController < ApplicationController

  def index
    @date = (if params[:date]
      Date.civil(params[:date][:year].to_i,params[:date][:month].to_i,params[:date][:day].to_i)
    else
      Date.today
    end) + 1
    @events = Event.where("event_date < ?", @date).includes(:eventable).order("event_date DESC")
  end

end
