class Target < ActiveRecord::Base

  has_many :events, :as => :eventable, :dependent => :destroy

  after_create do |target| 
    target.events.create!(:event_date => created_at)
    target.events.create!(:event_date => target_date)
  end

  def icon_url
    "events/target.png"
  end

  def title(date)
    if complete_date
      date <= created_at ? "Target Set" : date == complete_date ? "Target Complete" : "Target Due"
    else
      date <= created_at ? "Target Set" : "Target Due"
    end
  end

  def subtitle(date)
    return nil if date == complete_date
    "Due<br />" + target_date.strftime("%d %b")
  end

  def set_complete(date = Time.now)
    raise "Trying to complete an already complete Target (id:#{id})" if complete_date
    update_attribute("complete_date", date)
    events.create!(:event_date => date)
    events.where("event_date > ?",date).each {|e| e.destroy}
  end

end
