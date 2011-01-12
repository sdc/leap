module EventsHelper

  def classes_for(event)
    [event.eventable_type.downcase,
     event.subtitle ? "subtitle" : nil,
     event.background_class
    ]
  end

  def pretty_date(date)
    return "Today" if date.midnight == Date.today
    return "Yesterday" if date.midnight == Date.today - 1
    return "Tomorrow" if date.midnight == Date.today + 1
    return date.strftime("%d %b")
  end

end
