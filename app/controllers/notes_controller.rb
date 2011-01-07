class NotesController < ApplicationController

  def create
    Note.create!(params[:note])
    redirect_to events_url
  end

end
