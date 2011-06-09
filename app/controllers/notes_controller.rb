class NotesController < ApplicationController

  def create
    a = Note.create!(params[:note])
    redirect_to person_events_url(a.person)
  end

end
