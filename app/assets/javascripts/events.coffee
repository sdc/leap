###
events.coffee
All the stuff needed for the timeline to work properly
###

$(document).ready ->

  setupDatePickers =  (e) ->
    e.find('.datepicker').datepicker
      dateFormat:'D dd M yy'
      prevText: "<i class='icon-arrow-left icon-white'/>"
      nextText: "<i class='icon-arrow-right icon-white'/>"

  # Load and open the extended pane of an event
  $('.extend-button')
    .live 'ajax:complete', (event,data) ->
      e = $(event.target).closest('.event')
      e.find('.event-spinner').show()
      e.find('.extended').html data.responseText
      e.find('.extended').slideDown()
      e.find('.close-extend-button').show()
      e.find('.event-spinner').hide()
      e.find('.nav-tabs a:first').tab('show')
      setupDatePickers e
    .live 'click', (event) ->
      e = $(event.target).closest('.event')
      e.find('.event-spinner').show()
      e.find('.extend-button').hide()
  
  # Close the extended pane of an event
  close_event = (e) ->
    e.find('.extended').slideUp()
    e.find('.extend-button').show()
    e.find('.close-extend-button').hide()

  $('.close-extend-button').live 'click', (event) ->
    e = $(event.target).closest('.event')
    close_event(e)
  
  # Deleting Events
  $('.delete-event-button')
    .live 'click', (event) ->
      e = $(event.target).closest('.event')
      e.find('.event-spinner').show()
      e.find('.delete-event-button').hide()
    .live 'ajax:complete', (event) ->
      e = $(event.target).closest('.event')
      e.after "<div class='row alert alert-success'><button class='close' data-dismiss='alert'>×</button><b>Event Deleted!</b></div>"
      e.hide('slow')
      $('#main-pane > .alert').delay(4000).hide('slow')

  # Remote update of events if you edit them
  $('.edit-event-form')
    .live 'ajax:before', (event) ->
      e = $(event.target).closest('.event')
      close_event(e)
    .live 'ajax:complete', (event,data) ->
      e = $(event.target).closest('.event')
      e.replaceWith innerShiv data.responseText
      $('#main-pane > .alert').delay(4000).hide('slow')

  # Load more events into the bottom of the timeline if you click "more events"
  $('#more_events')
    .click ->
      $('#more_events').hide()
      $('#more_events_loading').show()
    .live 'ajax:complete', (event,data) ->
      unless data.responseText.length == 1
        $('#more_events_div').before innerShiv data.responseText
        d = $('#main-pane').children('.event').last().find('.event-date').attr('data-datetime')
        url = $('#more_events').attr('href').replace(/([&\?])date=[^&]*/,"$1date="+d)
        $('#more_events').attr('href',url).show()
      $('#more_events_loading').hide()

  # Trigger the "more events" if you scroll to the bottom of the page    
  $(window).scroll ->
    if ($(window).scrollTop() == $(document).height() - $(window).height())
      $('#more_events').click() unless $('#more_events').first().css('display') == "none"

  $('#expand-mini').live 'click',  -> 
    ul = $(this).closest("ul")
    ul.find('.body.short').hide()
    ul.find('.body.long').show()
    ul.find('.icon-chevron-right').hide()
    ul.find('a.delete-mini').show()
