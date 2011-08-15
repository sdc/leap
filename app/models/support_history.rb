class SupportHistory < Eventable

  after_create {|req| req.events.create!(:event_date => created_at, :transition => :create)}

end
