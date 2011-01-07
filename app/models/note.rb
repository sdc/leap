class Note < ActiveRecord::Base

  has_many :events, :as => :eventable

  validates :person_id, :presence => true

  after_create {|note| note.events.create!(:event_date => created_at)}

  def icon_url
    "events/mumble.png"
  end

  def title(date)
    "Mumble"
  end

end
