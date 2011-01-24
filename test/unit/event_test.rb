require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test "Generated methods exist" do
    ev = Event.new
    [:title,:subtitle,:icon_url,:body,:background_class,:details_pane].each do |m|
      assert_respond_to(ev,m)
    end
  end

  test "event_content_methods" do
    note = Note.create(:person_id => 1, :body => "Blah")
    event = Event.first
    assert_equal(event.body, note.body)
    assert_equal(event.title, note.title)
    assert_equal(event.icon_url, note.icon_url)
    assert_nil(event.subtitle)
  end

end
