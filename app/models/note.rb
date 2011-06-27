# = Note
#
# A note is a simple event consisting of a plain text body. It's intended to be used to capture learners' thoughts in order to
# turn them into SMART targets in a sturctured manner later on.
#
# This model is eventable. It creates a single event when it is created.

class Note < ActiveRecord::Base

  has_many :events, :as => :eventable, :dependent => :destroy
  belongs_to :person

  validates :person_id, :presence => true

  after_create {|note| note.events.create!(:event_date => created_at)}

  # Returns the note eventable icon URL. This is always the same.
  def icon_url
    "events/notes.png"
  end

  # Returns the note eventable  Title. This is always the same.
  def title
    "Mumble"
  end

  def sanitize_options
    {:tags => [:b,:i,:strong,:em]}
  end

end
