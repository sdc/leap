if @since
  page.insert_html :top, 'events', :partial => @events, :hidden => true
  @events.each do |event|
    page.visual_effect :slide_down, dom_id(event)
    page.delay 1 do
      page.visual_effect :highlight, dom_id(event)
    end
    page.call "watch_events", dom_id(event)
  end
else
  page.replace_html 'events', :partial => @events
  page.call "watch_events", "events"
end
page.replace_html 'event_header', :partial => "header"
