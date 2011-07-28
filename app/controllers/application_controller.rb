class ApplicationController < ActionController::Base

  protect_from_forgery

  layout proc{ |c| c.request.xhr? ? false : "application" }

  before_filter :set_user
  before_filter :set_topic
  before_filter :get_views

  def get_date
    if params[:date]
      if params[:date].kind_of? Hash
        Time.gm(*[:year,:month,:day].map{|x| params[:date][x].to_i})
      else
        Time.parse(params[:date])
      end
    else
      Time.now.midnight + 2.years
    end
  end

  private

  def set_user
    if Rails.env == "development"
      Person.user = @user = session[:user_id] ? Person.get(session[:user_id]) : nil
      @affiliation = session[:user_affiliation]
      redirect_to test_url unless @user && @affiliation
    else
      @affiliation = request.env["affiliation"] ? request.env["affiliation"].split("@").first.downcase : nil
      uname,domain = request.env["eppn"].downcase.split('@')
      uname = uname[0..-2] if @affiliation == "affiliate"
      Person.user = @user = Person.get(uname)
      render :text => "Problem contacting Shibboleth Service Provider" unless @user && @affiliation
    end
  end

  def set_topic
    if @affiliation == "staff"
      if params[:person_id]
        @topic = Person.get(params[:person_id],params[:refresh]) or raise "No such user mis_id:#{params[:person_id]}"
      elsif params[:course_id]
        @topic = Course.get(params[:course_id],params[:refresh]) or raise "No such course mis_id:#{params[:course_id]}"
      else
        @topic = @user
      end
    else
      @topic = @user
    end
  end

  def get_views
    @views = View.order("position").affiliation(@affiliation)
  end

end
