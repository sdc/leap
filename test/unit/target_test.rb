require 'test_helper'

class TargetTest < ActiveSupport::TestCase

  def a_target
    Target.create(:person_id => 1, :body => "Some body text!", :target_date => Time.now + 7.days)
  end

  test "Create Target with Event" do
    new_target = a_target
    assert(new_target.events)
    assert_equal(new_target.events.size,2)
  end

  test "Generated target set event methods" do
    new_target = a_target
    set_event = new_target.events.first
    assert_equal(set_event.event_date,new_target.created_at)
    assert_equal(set_event.person_id,new_target.person_id)
    assert_equal(set_event.icon_url,"events/target.png")
    assert_equal(set_event.title,"Target Set")
    assert_equal(set_event.body,new_target.body)
  end
    
  test "Generated target due event methods" do
    new_target = a_target
    due_event = new_target.events[1]
    assert_equal(due_event.person_id,new_target.person_id)
    assert_equal(due_event.icon_url,"events/target.png")
    assert_equal(due_event.title,"Target Due")
    assert_equal(due_event.body,new_target.body)
  end

  test "Set target complete" do
    new_target = a_target
    new_target.update_attribute("complete_date",Time.now + 1.day)
    new_target.notify_complete
    new_target.events.reload
    assert_equal(new_target.events.size,2)
    assert_equal(new_target.events.last.title,"Target Complete")
    assert_nil(new_target.events.last.subtitle)
    assert_equal(new_target.complete_date,new_target.events.last.event_date)
  end

end
