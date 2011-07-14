# = Note
#
# A note is a simple event consisting of a plain text body. It's intended to be used to capture learners' thoughts in order to
# turn them into SMART targets in a sturctured manner later on.
#
# This model is eventable. It creates a single event when it is created.

class ContactLog < Eventable

  belongs_to :contact, :class_name => "Person", :foreign_key => "contact_person_id"

  after_create {|contact_log| contact_log.events.create!(:event_date => created_at, :transition => :create, :about_person_id => contact_person_id)}

end
