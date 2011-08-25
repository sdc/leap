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

class CoursesController < ApplicationController
  
  skip_before_filter  :set_topic
  before_filter       :course_set_topic

  def show
    redirect_to "/404.html" unless @topic.kind_of? Course
    @next_timetable_event = @topic.timetable_events(:next).first
    begin
      mcourses = ActiveResource::Connection.new(Settings.moodle_host).
                 get("#{Settings.moodle_path}/webservice/rest/server.php?" +
                 "wstoken=#{Settings.moodle_token}&wsfunction=moodle_course_get_courses_by_idnumber&idnumber=" +
                  @topic.code)["MULTIPLE"]["SINGLE"]
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
  
  private
  
  def course_set_topic
    params[:course_id] = params[:id]
    set_topic
  end

end
