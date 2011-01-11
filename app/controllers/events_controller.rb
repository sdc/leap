class EventsController < ApplicationController

  def index
    @date = get_date + 1.day
    @since = (Time.parse(params[:since]) + 1) if params[:since]
    @events = Event.from_to(@since||@date - 2.week,@date).backwards.includes(:eventable)
    render :text => "" if @events.first.nil?
  end

  private

  def get_date
    params[:date] ? Time.gm(*[:year,:month,:day].map{|x| params[:date][x].to_i}) : Time.now.midnight
  end
 


end
