module EventsHelper

  def classes_for(event)
    [event.eventable_type.downcase,
     event.subtitle ? "subtitle" : nil,
     event.background_class
    ]
  end

end
