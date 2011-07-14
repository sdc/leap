class ReviewLine < Eventable

  belongs_to :review

  serialize :teachers

  after_create :notify_teachers

  def notify_teachers
    teachers.each do |t|
      events.create!(:person_id => t,:event_date => created_at, :transition => :create, :parent_id => review.events.creation.first.id, :about_person_id => person_id)
    end
  end

  def icon_url
    "events/reviews.png"
  end

  def extra_panes
    [["Edit","review_lines/edit"]]
  end

  def body
    comments
  end

end
