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

class PeopleController < ApplicationController

  skip_before_filter :set_topic
  before_filter      :person_set_topic, :except => [:search]
  before_filter      :staff_only, :only => [:search,:select]
  layout :set_layout

  def home
    @tiles = @topic.events.limit(23).map{|e| e.to_tile}
    @tiles << @topic.timetable_events(:next).first.to_tile if @topic.timetable_events(:next).any?
  end

  def show
    respond_to do |format|
      format.html
      format.json do 
        render :json => @topic.to_json(:methods => [:l3va], :except => [:photo])
      end
      format.jpg do
        if @topic.photo
          send_data @topic.photo, :disposition => 'inline', :type => "image/jpg"
        else
          redirect_to "/assets/noone.png"
        end
      end
    end
  end

  def search
    if params[:q]
      if params[:mis]
         @people = Person.mis_search_for(params[:q])
         @courses = Course.mis_search_for(params[:q])
      else
         @people = Person.search_for(params[:q]).order("surname,forename").limit(50)
         @courses = Course.search_for(params[:q]).order("year DESC,title").limit(50)
      end
    end
    @people  ||= []
    @courses ||= []
  end

  def select
    if params[:q]
      @people = Person.search_for(params[:q]).order("surname,forename").limit(20)
      render :json => @people.map{|p| {:id => p.id,:name => p.name, :readonly => p==@user}}.to_json
    end
  end

  def index
    redirect_to person_url(@user)
  end

  def next_lesson_block
    @next_timetable_event = @topic.timetable_events(:next).first
  end

  def my_courses_block
    @my_courses = @topic.my_courses
  end

  def targets_block
    @targets = @topic.targets.limit(8).where("complete_date is null")
  end

  def moodle_block
    begin
      mcourses = ActiveResource::Connection.new(Settings.moodle_host).
                 get("#{Settings.moodle_path}/webservice/rest/server.php?" +
                 "wstoken=#{Settings.moodle_token}&wsfunction=local_leapwebservices_get_user_courses&username=" +
                 @topic.username + Settings.moodle_user_postfix).body
      @moodle_courses = Nokogiri::XML(mcourses).xpath('//MULTIPLE/SINGLE').map{|x| [x.children[1].content,x.children[5].content]}
    rescue
      logger.error "Can't connect to Moodle: #{$!}"
      @moodle_courses = false
    end
  end

  def attendance_block
    if @topic.attendances.empty?
      @attendances = []
    else
      @attendances = @topic.attendances.last.siblings_same_year
    end
  end

  def poll_block
    @poll = SimplePoll.where(:id => Settings.current_simple_poll).first unless Settings.current_simple_poll.blank?
    @myans = @topic.simple_poll_answers.where(:simple_poll_id => @poll.id).first
  end



  private

  def person_set_topic
    params[:person_id] = params[:id]
    set_topic
  end

  def set_layout
    case action_name
    when /\_block$/ then false
    when "home" then "cloud"
    else "application"
    end
  end

end
