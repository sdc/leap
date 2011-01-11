require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "event_content_methods" do
    note = Note.create(:person_id => 1, :body => "Blah")
    event = Event.first
    assert_equal(event.body, note.body)
    assert_equal(event.title, note.title)
    assert_equal(event.icon_url, note.icon_url)
    assert_nil(event.subtitle)
  end
end
