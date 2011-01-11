class EventsController < ApplicationController

  def index
    @date = get_date + 1.day
    @since = (Time.parse(params[:since]) + 1) if params[:since]
    @events = Event.where("event_date < ? and event_date > ?", @date,@since||@date - 2.week).includes(:eventable).order("event_date DESC")
    render :text => "" if @events.first.nil?
  end

  private

  def get_date
    if params[:date]
      Time.gm(params[:date][:year].to_i,params[:date][:month].to_i,params[:date][:day].to_i)
    else
      Time.now.midnight
    end
  end
 


end
