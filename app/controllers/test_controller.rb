class TestController < ApplicationController

  def index
  end

  def login
    session[:user_id] = params[:login]
    session[:user_affiliation] = params[:affiliation]
    redirect_to events_url
  end


end
