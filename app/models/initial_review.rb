class InitialReview < Eventable

  after_create {|req| req.events.create!(:event_date => created_at, :transition => :create)}

  def icon_url
    "events/reviews.png"
  end

end
