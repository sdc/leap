class PeopleController < ApplicationController

  skip_before_filter :set_topic
  before_filter      :person_set_topic

  def show
    respond_to do |format|
      format.jpg do
        if File.exists? @topic.photo_path
          send_file(@topic.photo_path, :type => "image/jpeg", :disposition => 'inline')
        else
          redirect_to "/images/noone.jpg"
        end
      end
    end
  end

  private

  def person_set_topic
    params[:person_id] = params[:id]
    set_topic
  end

end
