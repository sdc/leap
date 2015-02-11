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
  before_filter      :person_set_topic, except: [:search]
  before_filter      :staff_only, only: [:search, :select]
  layout :set_layout

  def show
    respond_to do |format|
      format.html do
        @sidebar_links = parse_sidebar_links
        if Settings.home_page == "new"
          @tiles = @topic.events.where(eventable_type: "Target", transition: :overdue).
                   where(event_date: (Date.today - 1.week)..(Date.today + 1.month)).limit(8)
          @tiles += @topic.events.where(eventable_type: "Note").limit(8)
          @tiles += @topic.events.where(eventable_type: "MdlBadge").limit(8)
          @tiles = @tiles.sort_by(&:event_date).reverse.map(&:to_tile)
          @tiles.unshift(SimplePoll.where(id: Settings.current_simple_poll).first.to_tile) unless Settings.current_simple_poll.blank?
          ppdc = Settings.moodle_badge_block_courses.try(:split, ",")
          @tiles.unshift(@topic.mdl_badges.where(mdl_course_id: ppdc).last.to_course_tile) if ppdc && @topic.mdl_badges.where(mdl_course_id: ppdc).any?
          tracks = @topic.mdl_grade_tracks.group(:course_type).order(:created_at).flatten
          #@tiles.unshift(["english","maths","core"].reject{|ct| tracks.detect{|t| t.course_type == ct}}.first([3 - tracks.count,0].max).map do |ct|
          #  @topic.mdl_grade_tracks.where(:course_type => ct).last.try(:to_tile) or
          #  MdlGradeTrack.new(:course_type => ct).to_tile
          #end)
          @tiles.unshift(tracks.map { |x| x.to_tile })
          attendances = ["overall", "core", "maths", "english"].map { |ct| @topic.attendances.where(course_type: ct).last }.reject { |x| x.nil? }
          attendances.select! { |x| x.course_type != "overall" } if attendances.length == 2
          @tiles.unshift(attendances.map { |x| x.to_tile })
          #if @topic.attendances.where(:course_type => "overall").any?
          #  @tiles.unshift(@topic.attendances.where(:course_type => "overall").last.events.first.try :to_tile)
          #end
          @tiles.unshift(@topic.timetable_events(:next).first.to_tile) if @topic.timetable_events(:next).any?
          @tiles.unshift(GlobalNews.last.to_tile) if GlobalNews.any?
          @tiles = @tiles.flatten.reject { |t| t.nil? } #.uniq{|t| t.object}
          @on_home_page = true
          render action: "home"
        end
      end
      format.json do
        render json: @topic.to_json(methods: [:l3va, :gcse_english, :gcse_maths], except: [:photo])
      end
      format.jpg do
        if @topic.photo
          send_data @topic.photo, disposition: 'inline', type: "image/jpg"
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
    @page_title = "Search for #{params[:q]}"
    render Settings.home_page == "new" ? "cl_search" : "search"
  end

  def select
    if params[:q]
      @people = Person.search_for(params[:q]).order("surname,forename").limit(20)
      render json: @people.map { |p| {id: p.id, name: p.name, readonly: p==@user} }.to_json
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
      @moodle_courses = Nokogiri::XML(mcourses).xpath('//MULTIPLE/SINGLE').map do |course|
        Hash[:id,      course.xpath("KEY[@name='id']/VALUE").first.content,
             :name,    course.xpath("KEY[@name='fullname']/VALUE").first.content,
             :canedit, course.xpath("KEY[@name='canedit']/VALUE").first.content == "1"
            ]
      end
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
    @poll = SimplePoll.where(id: Settings.current_simple_poll).first unless Settings.current_simple_poll.blank?
    @myans = @topic.simple_poll_answers.where(simple_poll_id: @poll.id).first
  end



  private

  def person_set_topic
    params[:person_id] = params[:id]
    set_topic
  end

  def set_layout
    case action_name
    when /\_block$/ then false
    when "show" then Settings.home_page == "new" ? "cloud" : "application"
    when "search" then Settings.home_page == "new" ? "cloud" : "application"
    else "application"
    end
  end

  def parse_sidebar_links
    Settings.clidebar_links.split(/^\|/).drop(1)
            .map { |menu| menu.split("\n").reject(&:blank?).map(&:chomp) }
            .map { |menu| menu.first.split("|") + [menu.drop(1).map { |item| item.split("|") }] }
  end
end
