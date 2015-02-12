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

class ApplicationController < ActionController::Base
  protect_from_forgery

  layout proc { |c| c.request.xhr? ? false : "application" }

  before_filter :maintenance_mode
  before_filter :set_user
  before_filter :set_topic
  before_filter :get_views

  def set_date(default_offset = 0)
    begin
      @date = if params[:date]
                if params[:date].kind_of? Hash
                  Time.gm(*[:year, :month, :day].map { |x| params[:date][x].to_i })
                else
                  Time.parse(params[:date])
                end
              else
                Time.now + default_offset
      end
    rescue
      flash.notice = "Incorrect date entered! Using today instead."
      @date = Time.now
    end
  end

  private

  def maintenance_mode
    render file: "public/maintenance_mode.html.erb", layout: nil, locals: { message: Settings.maintenance_mode } unless Settings.maintenance_mode.blank?
  end

  def set_user
    if !Settings.ws_token.blank? && params[:token] == Settings.ws_token
      Person.user = @user = Person.get(Settings.ws_user)
      Person.affiliation = @affiliation = "staff"
    elsif Rails.env == "development"
      if params[:login_as]
        session[:user_affiliation] = params[:login_as]
        session[:user_id] = params[:id]
      end
      Person.user = @user = session[:user_id] ? Person.get(session[:user_id]) : nil
      Person.affiliation = @affiliation = session[:user_affiliation]
      redirect_to admin_test_url unless @user && @affiliation
    else
      aff_var = request.env["affiliation"] || request.env["HTTP_AJP_AFFILIATION"]
      if aff_var
        affs = aff_var.split(";").map { |a| a.split("@").first.downcase }
        Person.affiliation = @affiliation = ["staff", "student", "applicant", "affiliate"].find { |a| affs.include? a }
      end
      uname, domain = request.env[ env["eppn"] ? "eppn" : "REMOTE_USER"].try(:downcase).try(:split, '@')
      unless Settings.sdc.blank?
        if @affiliation == "student" && uname.match(/^[sne]/)
          uname.gsub!(/^s/, "10")
          uname.gsub!(/^n/, "20")
          uname.gsub!(/^e/, "30")
        end
      end
      Person.user = @user = Person.get(uname)
      render "admin/auth_error" unless @user && @affiliation
    end
  end

  def set_topic
    if @affiliation == "staff"
      if params[:person_id]
        @topic = Person.get(params[:person_id], params[:refresh]) 
      elsif params[:course_id]
        @topic = Course.get(params[:course_id], params[:refresh]) 
        @tutorgroup = params[:tutorgroup]
      else
        @topic = @user
      end
      redirect_to "/404.html" unless @topic
    else
      @topic = @user
    end
  end

  def get_views
    @views = View.top_level.order("position").in_list.for_user
  end

  def admin_page
    @user.admin? || redirect_to("/404.html")
    @topic = nil
  end

  def staff_only
    redirect_to "/404.html" unless @affiliation == "staff"
  end
end
