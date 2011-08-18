class CoursesController < ApplicationController
  
  skip_before_filter  :set_topic
  before_filter       :course_set_topic

  def show
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
