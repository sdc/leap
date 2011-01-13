module EventsHelper

  def classes_for(event)
    [event.eventable_type.downcase,
     event.subtitle ? "subtitle" : nil,
     event.background_class
    ]
  end

  def pretty_date(date, words = true)
    if words
      return "Today" if date.midnight == Date.today
      return "Yesterday" if date.midnight == Date.today - 1
      return "Tomorrow" if date.midnight == Date.today + 1
    end
    if date.year == Date.today.year
      return date.strftime("%d %b")
    else
      return date.strftime("%d %b %y")
    end
  end

  def pretty_time(date)
    return nil if date == date.midnight
    return date.strftime("%H.%M %P")
  end

end
