# Leap - Electronic Individual Learning Plan Software
# Copyright (C) 2011 South Devon College

# Leap is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Leap is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with Leap.  If not, see <http://www.gnu.org/licenses/>.

module EventsHelper

  def event_date(event)
    content_tag(:div, pretty_date(event.event_date), class: "date") +
    content_tag(:div, pretty_time(event.event_date), class: "time")
  end


  def special_title(thing, wrap = :div)
    text = case thing.class.name
    when "String" then thing
    when "Array"  then thing.map{ |t| content_tag(wrap, special_title(t)) }.join " "
    when "Date"   then pretty_date thing
    when "Time"   then pretty_date thing
    when "Course" then link_to_if @affiliation == "staff", thing.code, thing
    when "Person" then link_to_if @affiliation == "staff", thing.name, thing
    end
    (text and (text.size < 3  or text.last == "%")) ? content_tag(:span, text, class: "big") : text
  end
    
  def event_classes(event, mini = false)
    classes =  [mini ? "child-event" : "event", event.status, dom_id(event), dom_id(event.eventable), dom_class(event.eventable)]
    classes << "with_person" if @multi
    classes << "with_subtitle" if event.subtitle
    return classes
  end

  def extend_event_button(event)
    link_to(image_tag("actions/event_open.png"), 
            open_extended_event_url(event, person_id: event.person.mis_id), remote: true, class: "extend-button"
           ) +
    image_tag("actions/event_opened.png", class: "close-extend-button", style: "display:none") +
    image_tag("ajax-loader.gif", style: "display:none", class: "event-spinner", size: "16x16")
  end

  def delete_event_button(event)
    link_to image_tag("events/delete_event.png"), person_event_url(event.person, event), 
    method: :delete, remote: true,
    class:  "delete-event-button",
    data: {confirm: "This will delete the entire #{event.eventable_type.singularize.humanize.titleize}.\nAre you sure?"}
  end

  def pretty_date(date, options = {})
    return "Today" if date.midnight.to_date == Date.today
    return "Yesterday" if date.midnight.to_date == Date.today - 1
    return "Tomorrow" if date.midnight.to_date == Date.today + 1
    if date.year == Date.today.year
      return date.strftime("#{'%A ' if options[:day]}%d %b")
    else
      return date.strftime("#{'%A ' if options[:day]}%d %b %y")
    end
  end

  def pretty_time(date)
    return nil if date == date.midnight
    return date.strftime("%H.%M %P")
  end

  def event_format(text)
    simple_format(strip_tags(text))
  end

  def lesc(text)
    LatexToPdf.escape_latex(text)
  end

  def add_event_button(text = "Add")
    content_tag :div, width: "59px" do
      submit_tag text, class: "btn btn-primary pull-right", 
                       style: "margin-right:10px"
    end
  end

  def create_event_form(klass, html_options = {}, remote = false, &block)
    form_for(@topic.kind_of?(Person) ? @topic.send(klass.name.tableize).new : klass.new, remote: remote,
      url: "/events", html: html_options.reverse_merge(class: "form")
    ) do |f|
      if @topic.kind_of? Person
        concat(hidden_field_tag(:person_id, @topic.mis_id))
      else
        if @tutorgroup
          concat(select_tag :person_id, options_for_select(@topic.person_courses.where(tutorgroup: @tutorgroup).map{ |p| [p.person.name, p.person.mis_id] }), prompt: "Select a Person")
        else
          concat(select_tag :person_id, options_for_select(@topic.people.map{ |p| [p.name, p.mis_id] }), prompt: "Select a Person")
        end
      end
      concat(hidden_field_tag(:eventable_type, klass))
      block.call(f)
    end
  end
    

end
