# = Note
#
# A note is a simple event consisting of a plain text body. It's intended to be used to capture learners' thoughts in order to
# turn them into SMART targets in a sturctured manner later on.
#
# This model is eventable. It creates a single event when it is created.

class ContactLog < ActiveRecord::Base

  has_many :events, :as => :eventable, :dependent => :destroy
  belongs_to :person

  validates :person_id, :presence => true

  after_create {|contact_log| contact_log.events.create!(:event_date => created_at)}

  # Returns the note eventable icon URL. This is always the same.
  def icon_url
    "events/contact_log.png"
  end

  # Returns the note eventable  Title. This is always the same.
  def title
    "Contact Log"
  end

end
