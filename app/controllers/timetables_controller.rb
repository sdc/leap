class TimetablesController < ApplicationController
  
  def index
    if params[:date]
      if params[:date]["year"]
        @date = Date.civil((params[:date]["year"]).to_i,(params[:date]["month"]).to_i,(params[:date]["day"]).to_i).at_beginning_of_week
      else
        @date = Date.parse(params[:date]).at_beginning_of_week
      end
      @end_date = @date.next_week
    elsif params[:start_date] and params[:end_date]
      @date = Date.parse(params[:start_date])
      @end_date = Date.parse(params[:end_date]) + 1
    else
      @date = Date.today.at_beginning_of_week
      @end_date = @date.next_week
    end
    @registers = @topic.timetable_events(:from => @date, :to => @end_date)
    respond_to do |format|
      format.html 
      format.xml { render :xml => @topic }
    end
  end

end
