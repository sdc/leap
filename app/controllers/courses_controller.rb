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

class CoursesController < ApplicationController
  
  skip_before_filter  :set_topic
  before_filter       :course_set_topic

  def show
    @person_courses = @topic.person_courses.sort_by{|pc| pc.person.name(:surname_first => true)}
    respond_to do |format|
      format.html do
        @statuses = @topic.person_courses.select(:mis_status).map(&:mis_status).uniq
      end
      format.jpg { redirect_to "/assets/courses.png" }
    end
  end

  def next_lesson_block
    @next_timetable_event = @topic.timetable_events(:next).first
    render "people/next_lesson_block"
  end

  def moodle_block
    begin
      mcourses = ActiveResource::Connection.new(Settings.moodle_host).
                 get("#{Settings.moodle_path}/webservice/rest/server.php?" +
                 "wstoken=#{Settings.moodle_token}&wsfunction=local_leapwebservices_get_courses_by_idnumber&idnumber=" +
                  @topic.code)["MULTIPLE"].try(["SINGLE"])
      if mcourses.nil?
        @moodle_courses = []
      else
        @moodle_courses = mcourses.map{|x| x.respond_to?(:last) ? x.last : x["KEY"]}.map{|a| a.map{|b| [b["name"],b["VALUE"]]}}.map{|x| Hash[x]}.select{|x| x["visible"] == "1"}
      end
    rescue
      logger.error "Can't connect to Moodle: #{$!}"
      @moodle_courses = false
    end
    render "people/moodle_block"
  end

  def reviews_block
    @window = Settings.current_review_window
    @pub =   Review.where(:person_id => @topic.people.map{|p| p.id}, :published => true, :window => @window).count
    @unpub = Review.where(:person_id => @topic.people.map{|p| p.id}, :window => @window).count - @pub
  end

  def add
    @user.my_courses ||= []
    if @user.my_courses.include? @topic.id
      @user.my_courses.delete(@topic.id)
    else
      @user.my_courses << @topic.id
    end
    @user.save
    redirect_to @topic
  end


  
  private
  
  def course_set_topic
    params[:course_id] = params[:id]
    set_topic
  end

end
