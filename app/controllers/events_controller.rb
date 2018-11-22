# Leap - Electronic Individual Learning Plan Software
# Copyright (C) 2011 South Devon College

# Leap is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Leap is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with Leap.  If not, see <http://www.gnu.org/licenses/>.

class EventsController < ApplicationController

  def open_extended
    @event = @topic.events.find(params[:id])
    render :partial => "extended", :object => @event, :as => :event  
  end

  def show
    @event = @topic.events.find(params[:id])
  end

  def create
    et = params.delete(:eventable_type).tableize
    if @affiliation == "staff" or Settings.students_create_events.split(",").include? et
      @event = @topic.send(et).build(method("#{et.singularize}_params").call)
      if @event.save
        @event.strong_params_validate.each do |sp|
          event_event = @event.events.create!(event_params(sp))
          event_event.notifications.create!(notification_params(event_event.notification_params_validate))
        end
        @event.after_events_create if @event.respond_to? :after_events_create
        flash[:success] = "New #{et.singularize.humanize.titleize} created"
      else
        logger.error "*" * 1000
        @event.errors.each do |c,e|
          logger.error c.to_s + " -- " + e
        end
        flash[:error] = "#{et.singularize.humanize.titleize} could not be created!"
        flash[:details] = @event.errors.map{|c,e| "<b>#{c}:</b> #{e}"}.join "<br />"
      end
      if view = params[:redirect_to] 
        redirect_to params[:redirect_to]
      else
        begin
          render @event 
        rescue
          redirect_to :back
        end
      end
    else
      redirect_to "/404.html"
    end
  end

  def update
    @event = @topic.events.find(params[:id])
    et = @event.eventable_type.tableize
    if @affiliation == "staff" or Settings.students_update_events.split(",").include? et
      if @event.eventable.update_attributes(method("#{et.singularize}_params").call)
      # if @event.eventable.update_attributes(params[et.singularize])
        flash[:success] = "#{@event.eventable_type.humanize} updated"
      else
        flash[:error] = "#{@event.eventable_type.humanize} could not be updated!"
      end
      respond_to do |f|
        f.js   {render @event}
        f.html {redirect_to :back}
      end
    else
      redirect_to "/404.html"
    end
  end

  def destroy
    if @affiliation == "staff"
      @event = Event.find(params[:id])
    else
      @event = @topic.events.find(params[:id])
    end
    if @event.is_deletable?
      @event.delete
      if Event::where.not( id: @event.id ).where( eventable_type: @event.eventable_type, eventable_id: @event.eventable_id, person_id: @event.person_id ).empty?
        @event.eventable.delete
        flash[:success] = "#{@event.eventable_type.singularize.humanize.titleize} deleted"
      else
        if params[:eventtype] == 'Outcome' && @event.eventable_type == 'Intervention' && @event.eventable.is_a?(Intervention) && @event.eventable.respond_to?(:disc_text) && !@event.eventable.disc_text.nil?
          @event.eventable.disc_text = nil
          @event.eventable.save
        end
        flash[:success] = "#{@event.eventable_type.singularize.humanize.titleize} partially deleted"
      end
    else
      flash[:error] = "#{@event.eventable_type.singularize.humanize.titleize} could not be deleted"
    end
    respond_to do |f|
      f.html {redirect_to :back}
      f.js { head :no_content }
    end
  end

  private

    def event_params(params_passed)
      params = ActionController::Parameters.new(event: params_passed)
      params.require(:event).permit(:person_id, :event_date, :transition, :parent_id)
    end

    def eventable_params
      params.require(:eventable).permit(:event_date, :transition)
    end

    def aspiration_params
      params.require(:aspiration).permit(:aspiration)
    end

    def achievement_params
      params.require(:achievement).permit(:body, :year)
    end

    def attendance_params
      params.require(:attendance).permit(:week_beginning, :att_year, :att_week, :course_type)
    end  

    def contact_log_params
      params.require(:contact_log).permit(:body)
    end   

    def disciplinary_params
      params.require(:disciplinary).permit(:level, :body)
    end  

    def entry_req_met_params
      params.require(:entry_req_met).permit(:met, :entry_req_id, :no_but)
    end   

    def event_note_params
      params.require(:event_note).permit(:body, :parent_event_id, :parent_id)
    end   

    def goal_params
      params.require(:goal).permit(:body)
    end 

    def induction_question_params
      params.require(:induction_question).permit(:question, :answer)
    end  

    def initial_review_params
      params.require(:initial_review).permit(:body, :created_at, :created_by_id, :progress_id, :target_grade)
    end 

    def intervention_params
      params.require(:intervention).permit(:disc_text, :incident_date, :pi_type, :referral, :referral_category, :referral_text, :workshops)
    end  

    def mdl_badge_params
      params.require(:mdl_badge).permit(:body, :image_url, :mdl_course_id, :person_id, :title, :created_at)
    end  

    def mdl_grade_track_params
      params.require(:mdl_grade_track).permit(:course_type, :mag, :mdl_id, :name, :tag, :total, :completion_total, :completion_out_of, :created_at, :created_by_id)
    end  

    def meeting_outcome_params
      params.require(:meeting_outcome).permit(:body, :created_by_id, :person_id, :title)
    end                         

    def note_params
      params.require(:note).permit(:body)
    end    

    def pathway_params
      params.require(:pathway).permit(:pathway,:subject)
    end  

    def profile_question_params
      params.require(:profile_question).permit(:question, :answer)
    end  

    def progress_review_params
      params.require(:progress_review).permit(:attendance, :body, :completed_by, :created_at, :id, :level, :number, :progress_id, :working_at)
    end  

    def progression_review_params
      params.require(:progression_review).permit(:approved, :reason)
    end  

    def qualification_params
      params.require(:qualification).permit(:awarding_body, :grade, :predicted, :qual_type, :seen, :title, :created_at, :import_type)
    end  

    def review_params
      params.require(:review).permit(:attendance, :published, :body, :window)
    end                         

    def review_line_params
      params.require(:review_line).permit(:body, :quality, :attitude, :punctuality, :completion, :window, :unit, :review_id)
    end    

    def simple_poll_answer_params
      params.require(:simple_poll_answer).permit(:answer, :created_by, :person_id, :simple_poll_id)
    end  

    def support_history_params
      params.require(:support_history).permit(:body, :category)
    end   

    def support_request_params
      params.require(:support_request).permit(:difficulties, :sessions, :workshop)
    end      

    def support_strategy_params
      params.require(:support_strategy).permit(:body, :agreed_date, :completed_date, :declined_date, :event_id)
    end 

    def target_params
      params.require(:target).permit(:body, :actions, :reflection, :target_date, :complete_date, :drop_date, :event, :event_id)
    end   

    def tt_activity_params
      params.require(:tt_activity).permit(:body, :start_time, :category, :repeat_type, :repeat_number, :timetable_length, :tmp_time, :tmp_date)
    end      

    def work_package_params
      params.require(:work_package).permit(:wp_type, :description, :learnt, :next_steps, :days)
    end 

    def notification_params(params_passed)
      params = ActionController::Parameters.new(notification: params_passed)
      params.require(:notification).permit(:person_id, :event_id, :notified)
    end                                
end
