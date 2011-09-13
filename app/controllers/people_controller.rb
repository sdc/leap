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
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

class PeopleController < ApplicationController

  skip_before_filter :set_topic
  before_filter      :person_set_topic, :except => [:search]
  before_filter      :staff_only, :only => [:search]

  def show
    respond_to do |format|
      format.html do
        @next_timetable_event = @topic.timetable_events(:next).first
        @attendances = @topic.attendances.last.siblings_same_year
        @targets = @topic.targets.limit(8).where("complete_date is null")
        begin
          mcourses = ActiveResource::Connection.new(Settings.moodle_host).
                     get("#{Settings.moodle_path}/webservice/rest/server.php?" +
                     "wstoken=#{Settings.moodle_token}&wsfunction=moodle_course_get_user_courses&username=" +
                     @topic.username + Settings.moodle_user_postfix)["MULTIPLE"]["SINGLE"]
          if mcourses.nil?
            @moodle_courses = []
          else
            @moodle_courses = mcourses.map{|x| x.respond_to?(:last) ? x.last : x["KEY"]}.map{|a| a.map{|b| [b["name"],b["VALUE"]]}}.map{|x| Hash[x]}.select{|x| x["visible"] == "1"}
          end
        rescue
          logger.error "Can't connect to Moodle: #{$!}"
          @moodle_courses = false
        end
      end
      format.jpg do
        if File.exists? "#{Rails.root}/public/photos/#{@topic.mis_id}.jpg"
          redirect_to "/photos/#{@topic.mis_id}.jpg"
        else
          redirect_to "/images/noone.png"
        end
      end
    end
  end

  def search
    if params[:q]
      if params[:commit] == "Search"
         @people = Person.search_for(params[:q]).order("surname,forename").limit(50)
         @courses = Course.search_for(params[:q]).order("year DESC,title").limit(50)
      else
        @people = Person.mis_search_for(params[:q])
      end
    end
    @people  ||= []
    @courses ||= []
    render :layout => "search"
  end

  def index
    redirect_to person_url(@user)
  end

  private

  def person_set_topic
    params[:person_id] = params[:id]
    set_topic
  end

end
