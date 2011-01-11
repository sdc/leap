module EventsHelper

  def classes_for(event)
    [event.eventable_type.downcase,
     event.subtitle ? "subtitle" : nil
    ]
  end

end
