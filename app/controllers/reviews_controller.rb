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

class ReviewsController < ApplicationController

  before_filter      :staff_only, :only => [:index,:new]

  def show
    respond_to do |format|
      format.json do 
        review = getReview(getKnownReviewType, params[:id])
        render :json => review.as_json(
          :include => [:progress, :person => {:methods => :name, :except => [:photo]}],
          :methods => [:pretty_created_at, :pretty_body]
        )
      end
    end
  end

  def index
    respond_to do |format|
      format.json do 
        @progresses = @topic.progresses.where(:course_status => 'Active').order("course_type ASC")
        render :json => @progresses.as_json()
      end
    end
  end

  def new
    respond_to do |format|
      format.json do 
        render :json => @topic.progresses.find(params[:progress_id]).as_json();
      end
    end
  end

  private

  def getKnownReviewType
    if ( !request.path.include?('progress_reviews') && !request.path.include?('initial_reviews'))
      raise "Unknown review type" # This shouldn't happen unless a different resource is added.
    end

    return (request.path.include? 'progress_reviews') ? 'progress' : 'initial'
  end

  def getReview(type, id)
    if (type == 'progress')
      return @topic.progress_reviews.find(id)
    end

    return @topic.initial_reviews.find(id)
  end

end
