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

require 'misc/misc_dates'

class PeopleController < ApplicationController

  skip_before_filter :set_topic
  before_filter      :person_set_topic, :except => [:search]
  before_filter      :staff_only, :only => [:search,:select]
  layout :set_layout

  def show
    respond_to do |format|
      format.html do
        @sidebar_links = parse_sidebar_links
        misc_dates = MISC::MiscDates.new
        if Settings.home_page == "progress" && !@topic.staff?
          ## TODO - Remove this. Currently @progress_bar array is required in order to map attendance. Need a better way of doing this.
          @progresses = @topic.progresses
          @progress_bar = {}
          @progresses.each do |progress|
            @progress_bar[progress.uio_id] = {}
            @progress_bar[progress.uio_id]['course'] = progress
            if ["core", "english", "maths"].include? progress.course_type
              @progress_bar[progress.uio_id]['attendance'] = @topic.attendances.where(:course_type => progress.course_type).where(["week_beginning >= ?", misc_dates.start_of_acyr] ).last
            else
              @progress_bar[progress.uio_id]['attendance'] = @topic.attendances.where(:enrol_course => progress.course_code).where(["week_beginning >= ?", misc_dates.start_of_acyr] ).last
            end
            @progress_bar[progress.uio_id]['initial'] = progress.initial_reviews.last
            @progress_bar[progress.uio_id]['reviews'] = []
            @reviews = progress.progress_reviews.order("number ASC")
            @reviews.each do |review|
              key = review.number
              @progress_bar[progress.uio_id]['reviews'][key] = review
            end
          end
          ppdc = Settings.moodle_badge_block_courses.try(:split,",")
          @badges = @topic.mdl_badges.where(:mdl_course_id => ppdc) if ppdc && @topic.mdl_badges.where(:mdl_course_id => ppdc).any?
          @aspiration = @topic.aspirations.last.aspiration if @topic.aspirations.present?
          @notifications = @user.notifications.where(:notified => false)
        else
          @tiles = @topic.events.where(:eventable_type => "Target",:transition => :overdue).
                   where(:event_date => (Date.today - 1.week)..(Date.today + 1.month)).limit(8)
          @tiles += @topic.events.where(:eventable_type => "Note").limit(8)
          @tiles += @topic.events.where(:eventable_type => "MdlBadge").limit(8)
          @tiles = @tiles.sort_by(&:event_date).reverse.map(&:to_tile)
          @tiles.unshift(SimplePoll.where(:id => Settings.current_simple_poll).first.to_tile) unless Settings.current_simple_poll.blank?
          ppdc = Settings.moodle_badge_block_courses.try(:split,",")
          @tiles.unshift(@topic.mdl_badges.where(:mdl_course_id => ppdc).last.to_course_tile) if ppdc && @topic.mdl_badges.where(:mdl_course_id => ppdc).any?
          tracks = ["core","maths","english"].map{|ct| @topic.mdl_grade_tracks.where(:course_type => ct).last}.reject{|x| x.nil?}
          @tiles.unshift(tracks.map{|x| x.to_tile})
          misc_dates = MISC::MiscDates.new
          attendances = ["overall","core","maths","english"].map{|ct| @topic.attendances.where(:course_type => ct).where(["week_beginning >= ?", misc_dates.start_of_acyr] ).last}.reject{|x| x.nil?}
          attendances.select!{|x| x.course_type != "overall"} if attendances.length == 2
          @tiles.unshift(attendances.map{|x| x.to_tile})
          @tiles.unshift(@topic.timetable_events(:next).first.to_tile) if @topic.timetable_events(:next).any?
          for news_item in GlobalNews.where( :active => true, :from_time => [nil,DateTime.new(0)..DateTime.now], :to_time => [nil,DateTime.now..DateTime.new(9999)] ).order("id DESC") do
            @tiles.unshift(news_item.to_tile)
          end
          @tiles = @tiles.flatten.reject{|t| t.nil?} #.uniq{|t| t.object}
        end
        if Settings.home_page == "new" || Settings.home_page == "progress"
          @nextLesson = @topic.timetable_events(:next).first.to_tile if @topic.timetable_events(:next).any? 
          @on_home_page = true
          render :action => "home"
        end
      end
      format.json do 
        render :json => @topic.as_json(:methods => [:l3va,:gcse_english,:gcse_maths,:target_gcse], :except => [:photo])
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
    @page_title = "Search for #{params[:q]}"
    render Settings.home_page == "new" || Settings.home_page == "progress" ? "cl_search" : "search"
  end

  def select
    if params[:q]
      @people = Person.search_for(params[:q]).where(:staff => true).order("surname,forename").limit(20)
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
    when "show" then Settings.home_page == "new" || Settings.home_page == "progress" ? "cloud" : "application"
    when "search" then Settings.home_page == "new" || Settings.home_page == "progress" ? "cloud" : "application"
    else "application"
    end
  end

  def parse_sidebar_links
    Settings.clidebar_links.split(/^\|/).drop(1)
            .map{|menu| menu.split("\n").reject(&:blank?).map(&:chomp)}
            .map{|menu| menu.first.split("|") + [menu.drop(1).map{|item| item.split("|")}]}
  end

end
