class ContactLogsController < ApplicationController

  def create
    @topic.contact_logs.create(params[:contact_log])
    redirect_to person_events_url(@topic, :eventable_type => {:ContactLog => true})
  end

end
