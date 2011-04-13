class RegistersController < ApplicationController
  
  def index
    if params[:date]
      @date = Date.parse(params[:date]).at_beginning_of_week
      @end_date = @date.next_week
    elsif params[:start_date] and params[:end_date]
      @date = Date.parse(params[:start_date])
      @end_date = Date.parse(params[:end_date]) + 1
    else
      @date = Date.today.at_beginning_of_week
      @end_date = @date.next_week
    end
    @registers = @topic.register_event_details_slots.find(:all,:conditions => ["planned_start_date <= ? and planned_end_date >= ?",@end_date,@date])
    respond_to do |format|
      format.html 
      format.xml  { render :text => 
	   (@registers.to_xml(:include => 
		{:register_event => {}, :register_event_slot => {:methods => ["count_learners"]}})) }
    end
  end

end
