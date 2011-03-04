class PeopleController < ApplicationController

  skip_before_filter :set_topic
  before_filter      :person_set_topic, :except => [:search]

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
