class ReviewLinesController < ApplicationController

  def update
    @review_line = ReviewLine.find(params[:id])
    @event = Event.find(params[:event_id])
    @events = @review_line.events
    @review_line.update_attributes(params[:review_line])
    render @event
  end

end
