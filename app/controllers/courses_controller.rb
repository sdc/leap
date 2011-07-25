class CoursesController < ApplicationController

  def show
    @course = Course.get(params[:id])
    redirect_to courses_views_url(@course)
  end

end
