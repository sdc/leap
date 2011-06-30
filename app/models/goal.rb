class Goal < Eventable

  after_create do |target| 
    target.events.create!(:event_date => created_at)
  end

end
