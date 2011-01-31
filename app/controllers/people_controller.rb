class PeopleController < ApplicationController

  skip_before_filter :set_topic
  before_filter      :person_set_topic

  def show
    respond_to do |format|
      format.jpg do
        send_file(MisConnector.person_photo(@topic), :type => "image/jpeg", :disposition => 'inline')
      end
    end
  end

  private

  def person_set_topic
    params[:person_id] = params[:id]
    set_topic
  end

end
