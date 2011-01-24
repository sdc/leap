class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_user

  def set_user
    if session[:user_id]
      @user = Person.get(session[:user_id])
    end
  end

end
