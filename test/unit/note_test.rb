require 'test_helper'

class NoteTest < ActiveSupport::TestCase

  test "Create Note with Event" do
    new_note = Note.create(:person_id => 1, :body => "Some body text!")
    assert(new_note.events)
    assert_equal(new_note.events.size,1)
    new_event = new_note.events.first
    assert_equal(new_event.event_date,new_note.created_at)
    assert_equal(new_event.person_id,new_note.person_id)
  end

end
