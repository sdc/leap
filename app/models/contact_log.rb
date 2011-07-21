# = Note
#
# A note is a simple event consisting of a plain text body. It's intended to be used to capture learners' thoughts in order to
# turn them into SMART targets in a sturctured manner later on.
#
# This model is eventable. It creates a single event when it is created.

class ContactLog < Eventable

  after_create {|contact_log| contact_log.events.create!(:event_date => created_at, :transition => :create)}

  def title; "Contact Log: #{created_by.name}" end

  def icon_url
    "/people/#{created_by.mis_id}.jpg"
  end

end
