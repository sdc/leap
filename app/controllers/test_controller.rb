class TestController < ApplicationController

  skip_before_filter :set_user

  def index
  end

  def login
    session[:user_id] = params[:login]
    session[:user_affiliation] = params[:affiliation]
    redirect_to person_url(Person.find_by_mis_id(session[:user_id]))
  end

end
