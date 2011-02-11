class Goal < ActiveRecord::Base

  has_many :events, :as => :eventable, :dependent => :destroy
  belongs_to :event

  after_create do |target| 
    target.events.create!(:event_date => created_at)
  end

  def icon_url
    "events/goal.png"
  end

  def title
    "Goal"
  end

  def status
    :current
  end

end
