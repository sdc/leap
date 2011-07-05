# = Note
#
# A note is a simple event consisting of a plain text body. It's intended to be used to capture learners' thoughts in order to
# turn them into SMART targets in a sturctured manner later on.
#
# This model is eventable. It creates a single event when it is created.

class Note < Eventable


  after_create {|note| note.events.create!(:event_date => created_at, :transition => :create)}

  def sanitize_options
    {:tags => [:b,:i,:strong,:em]}
  end

end
