class CoursesController < ApplicationController
  
  skip_before_filter  :set_topic
  before_filter       :course_set_topic

  def show
  end
  
  private
  
  def course_set_topic
    params[:course_id] = params[:id]
    set_topic
  end

end
