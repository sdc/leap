module EventsHelper

  def tab(event_id,text,klass)
    link_to_function content_tag(:li, text), "$$('##{event_id} .tab').each(function(t){t.hide()});$$('##{event_id} .#{klass}').first().show()"
  end

  def classes_for(event)
    [event.eventable_type.downcase,
     event.subtitle ? "subtitle" : nil,
     event.status
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

  def event_filter_url(topic,options = {})
    params = {:eventable_type => {}, :transition => {}}
    [:eventable_type,:transition].each do |k|
      if options[k]
        if options[k].respond_to? "first"
          options[k].each{|et|params[k][et] = 1}
        else
          params[k][options[k]] = 1
        end
      end
    end
    if options[:anchor]
      return person_events_url(topic,params.merge(:anchor => options[:anchor]))
    else
      return person_events_url(topic,params)
    end
  end

end
