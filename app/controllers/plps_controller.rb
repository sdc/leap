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

class PlpsController < ApplicationController
  
  before_filter       :staff_only

  def show
    show_plp_tabs = Settings.plp_tabs.split(',')

    render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found and return if !['overview','reviews','support','checklist','badges','achievement','progress'].include? params[:id] or !show_plp_tabs.include? params[:id]

    @person_courses = if @tutorgroup
      @topic.person_courses.includes(:person => "mdl_grade_tracks").where(:tutorgroup => @tutorgroup).sort_by{|pc| pc.person.name(:surname_first => true)}
    else
      @topic.person_courses.includes(:person => "mdl_grade_tracks").sort_by{|pc| pc.person.name(:surname_first => true)}
    end

    respond_to do |format|
      format.html do
        render :partial => '/courses/plp_overview', :locals => { :id => :course_id } if ['overview'].include? params[:id]
        render :partial => '/courses/plp_reviews', :locals => { :id => :course_id } if ['reviews'].include? params[:id]
        render :partial => '/courses/plp_support', :locals => { :id => :course_id } if ['support'].include? params[:id]
        render :partial => '/courses/plp_checklist', :locals => { :id => :course_id } if ['checklist'].include? params[:id]
        render :partial => '/courses/plp_badges', :locals => { :id => :course_id } if ['badges'].include? params[:id]
        render :partial => '/courses/plp_achieve', :locals => { :id => :course_id } if ['achievement'].include? params[:id]
        render :partial => '/courses/plp_progress', :locals => { :id => :course_id } if ['progress'].include? params[:id]
      end
    end
  end

end
