class SupportRequest < Eventable

  serialize :sessions
  serialize :difficulties

  after_create {|req| req.events.create!(:event_date => created_at, :transition => :create)}

  def body_partial; true end

end
