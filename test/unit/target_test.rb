require 'test_helper'

class TargetTest < ActiveSupport::TestCase

  test "Create Target with Event" do
    new_target = Target.create(:person_id => 1, :body => "Some body text!", :target_date => Time.now + 7.days)
    assert(new_target.events)
    assert_equal(new_target.events.size,2)

    set_event = new_target.events.first
    assert_equal(set_event.event_date,new_target.created_at)
    assert_equal(set_event.person_id,new_target.person_id)
    assert_equal(set_event.icon_url,"events/target.png")
    assert_equal(set_event.title,"Target Set")
    assert_equal(set_event.body,new_target.body)
    
    due_event = new_target.events[1]
    assert_equal(due_event.person_id,new_target.person_id)
    assert_equal(due_event.icon_url,"events/target.png")
    assert_equal(due_event.title,"Target Due")
    assert_equal(due_event.body,new_target.body)

    new_target.set_complete(Time.now + 1.day)
    new_target.events.reload
    assert_equal(new_target.events.size,2)
    assert_equal(new_target.events.last.title,"Target Complete")
    assert_nil(new_target.events.last.subtitle)
    assert_equal(new_target.complete_date,new_target.events.last.event_date)
  end

end
