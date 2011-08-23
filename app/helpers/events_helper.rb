module EventsHelper

  def tab(event_id,text,klass=nil)
    klass ||= text.titleize.tr(" ","").underscore
    link_to_function content_tag(:li, text), "$$('##{event_id} .tab').each(function(t){t.hide()});$$('##{event_id} .#{klass}').first().show()"
  end

  def title_class(thing)
    thing.size < 4 ? "big" : nil
  end

  def special_title(thing)
    text = case thing.class.name
    when "String" : thing
    when "Array"  : thing.map{|t| content_tag(:div, special_title(t), :class => "double_title")}.join
    when "Date"   : pretty_date thing
    when "Time"   : pretty_date thing
    when "Course" : link_to_if @affiliation == "staff", thing.code, thing
    when "Person" : link_to_if @affiliation == "staff", thing.name, thing
    end
    (text.size < 3  or text.last == "%") ? content_tag(:span,text,:class => "big") : text
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

end
