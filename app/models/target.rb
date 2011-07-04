# = Target
#
# These are (hopefully) SMART targets stored against a person. They can be attached to any other event in the system, usually
# taken to be the event which inspired the target or towards which the target is working. 
#
# This model is eventable. It creates two events when set, one showing the creation of the target and one as a reminder of the target's
# completion date. When it is completed it new event noting its completion.
#
class Target < Eventable

  belongs_to :event
  belongs_to :set_by, :class_name => "Person", :foreign_key => "set_by_person_id"

  after_create do |target| 
    target.events.create!(:event_date => created_at,  :parent_id => event_id, :transition => :start)
    target.events.create!(:event_date => target_date, :parent_id => event_id, :transition => :overdue)
  end

  # Returns the target eventable icon url. Complete or not?
  def icon_url
    status == :complete ? "events/target-complete.png" : "events/target.png"
  end

  # Returns the target eventable title.
  def title(tr)
    case tr
    when :complete : "Target Complete"
    when :start    : "Target Set"
    else "Target Due"
    end
  end

  # Returns the target eventable subtitle. This is the target due date unless the event is the completion of the target, when it is +nil+.
  def subtitle(tr)
    return ["Due", target_date] unless [:start,:overdue].include?(tr)
  end

  # Returns the status for this event, it is +:current+ unless it is a completion event, when it is +:complete+.
  # TODO: Have an incomplete status too.
  def status
    complete_date ? :complete : :current
  end

  # Returns the partial to render for the details pane
  def extra_panes
    [["Details","targets/details"]]
  end

  # Run this after an event is completed to create the completion event.
  def notify_complete
    raise "Trying to notify completion of an incomplete Target (id:#{id})" unless complete_date
    events.create!(:event_date => complete_date, :transition => :complete)
  end

  def body_partial
    true
  end
  
  def sanitize_options
    {:tags => [:b,:i,:strong,:em]}
  end  

end
