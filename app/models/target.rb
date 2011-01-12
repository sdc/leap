# = Target
#
# These are (hopefully) SMART targets stored against a person. They can be attached to any other event in the system, usually
# taken to be the event which inspired the target or towards which the target is working. 
#
# This model is eventable. It creates two events when set, one showing the creation of the target and one as a reminder of the target's
# completion date. When it is completed it removes any other future events and creates a new event noting its completion.
#
class Target < ActiveRecord::Base

  has_many :events, :as => :eventable, :dependent => :destroy

  after_create do |target| 
    target.events.create!(:event_date => created_at)
    target.events.create!(:event_date => target_date)
  end

  # Returns the target eventable icon url. This is always the same.
  def icon_url
    "events/target.png"
  end

  # Returns the target eventable title. There are three possible titles depending on the event_date passed in:
  # created_date::                       Target Set
  # completed_date::                     Target Complete
  # between created and completed_date:: Target Due
  def title(date)
    if complete_date
      date <= created_at ? "Target Set" : date == complete_date ? "Target Complete" : "Target Due"
    else
      date <= created_at ? "Target Set" : "Target Due"
    end
  end

  # Returns the target eventable subtitle. This is the target due date unless the event is the completion of the target, when it is +nil+.
  def subtitle(date)
    return nil if date == complete_date
    "Due " + target_date.strftime("%d %b")
  end

  # Returns the background class for displaying this event, it is +bg_reminder+ unless it is a completion event, when it is +bg_complete+.
  def background_class(date)
    date == complete_date ? "bg_complete" : "bg_reminder"
  end

  # Sets the target as complete on +date+. Any future events attached to this eventable are removed from the system (and returned). A
  # new completion event is created.
  def set_complete(date = Time.now)
    raise "Trying to complete an already complete Target (id:#{id})" if complete_date
    update_attribute("complete_date", date)
    events.create!(:event_date => date)
    events.where("event_date > ?",date).each {|e| e.destroy}
  end

end
