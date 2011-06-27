class ApplicationController < ActionController::Base

  protect_from_forgery

  layout proc{ |c| c.request.xhr? ? false : "application" }

  before_filter :set_user
  before_filter :set_topic

  private

  def set_user
    @user = session[:user_id] ? Person.get(session[:user_id]) : nil
    @affiliation = session[:user_affiliation]
    redirect_to test_url unless @user && @affiliation
  end

  def set_topic
    if @affiliation == "staff"
      if params[:person_id]
        @topic = Person.get(params[:person_id]) or raise "No such user mis_id:#{params[:person_id]}"
      elsif params[:course_id]
        raise("Courses not implemented yet!")
      else
        @topic = @user
      end
    else
      @topic = @user
    end
  end

end
