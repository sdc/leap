class PeopleController < ApplicationController

  skip_before_filter :set_topic
  before_filter      :person_set_topic, :except => [:search]

  def show
    respond_to do |format|
      format.html do
        @next_timetable_event = @topic.timetable_events(:next).first
        @attendances = @topic.attendances
        @targets = @topic.targets.limit(8).where("complete_date is null")
        begin
          @moodle_courses = ActiveResource::Connection.new(Ilp2::Application.config.moodle_host).
                           get("#{Ilp2::Application.config.moodle_path}/webservice/rest/server.php?" +
                           "wstoken=#{Ilp2::Application.config.moodle_token}&wsfunction=moodle_course_get_user_courses&username=#{@topic.username}")["MULTIPLE"]["SINGLE"].
                           map{|x| x["KEY"]}.map{|a| a.map{|b| [b["name"],b["VALUE"]]}}.map{|x| Hash[x]}.select{|x| x["visible"] == "1"}
        rescue
          @moodle_courses = false
        end
      end
      format.jpg do
        if File.exists? @topic.photo_path
          send_file(@topic.photo_path, :type => "image/jpeg", :disposition => 'inline')
        else
          redirect_to "/images/noone.png"
        end
      end
    end
  end

  def search
    if params[:q]
      if params[:search_mis] == "1"
        @people = Person.mis_search_for(params[:q])
      else
        @people = Person.search_for(params[:q])
      end
    end
  end

  private

  def person_set_topic
    params[:person_id] = params[:id]
    set_topic
  end

end
