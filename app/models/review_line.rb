class ReviewLine < Eventable

  belongs_to :review

  after_create {|rl| rl.events.create!(:event_date => created_at, :transition => :create, :parent_id => review.events.creation.first.id)}

  def icon_url
    "events/reviews.png"
  end

end
