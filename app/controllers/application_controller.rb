class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_user
  before_filter :set_topic

  def set_user
    @user = Person.get(session[:user_id])
    @affiliation = session[:user_affiliation]
    redirect_to test_url unless @user && @affiliation
  end

  def set_topic
    if @affiliation == "staff"
      if params[:person_id]
        @topic = Person.get(params[:person_id]) or raise "No such user uln:#{params[:person_id]}"
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
