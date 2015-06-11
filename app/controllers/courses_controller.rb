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
  before_action :staff_only
  skip_before_action :set_topic
  before_action :course_set_topic

  def show
    render json: @topic
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
