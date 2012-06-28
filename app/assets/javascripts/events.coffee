###
events.coffee
All the stuff needed for the timeline to work properly
###

$(document).ready ->

  # Don't bother doing any of this if there's no events on the page
  unless $('#events') == []

    # Load and open the extended pane of an event
    $('.extend_button')
      .live 'ajax:complete', (event,data) ->
        e = $(event.target).closest('.event')
        e.find('.extend_spinner').show()
        e.find('.extended .inner').replaceWith data.responseText
        e.find('.tabs').tabs()
        e.find('.extended').slideDown()
        e.find('.close_extend_button').show()
        e.find('.extend_spinner').hide()
      .live 'click', (event) -> 
        e = $(event.target).closest('.event')
        e.find('.extend_spinner').show()
        e.find('.extend_button').hide()
    
    # Close the extended pane of an event
    $('.close_extend_button').live 'click', (event) ->
      e = $(event.target).closest('.event')
      e.find('.extended').slideUp()
      e.find('.extend_button').show()
      e.find('.close_extend_button').hide()
    
    # Spinner for deleting an event
    $('.delete_event_button').live 'click', (event) ->
      e = $(event.target).closest('.event')
      e.find('.delete_spinner').show()
      e.find('.delete_event_button').hide()

    # Update an event over AJAX if you change its details in the "Extra Details" tab
    $('form.event_update_form').live 'ajax:complete', (event,data) ->
      e = $(event.target).closest('.event')
      e.replaceWith(data.responseText)

    # Load more events into the bottom of the timeline if you click "more events"
    $('#more_events')
      .click ->
        $('#more_events').hide()
        $('#more_events_loading').show()
      .live 'ajax:complete', (event,data) ->
        unless data.responseText.length == 1
          $('#events').append innerShiv data.responseText
          d = $('#events').children('.event').last().find('time').attr('datetime')
          url = $('#more_events').attr('href').replace(/([&\?])date=[^&]*/,"$1date="+d)
          $('#more_events').attr('href',url).show()
        $('#more_events_loading').hide()

    # Trigger the "more events" if you scroll to the bottom of the page    
    $(window).scroll ->
      if ($(window).scrollTop() == $(document).height() - $(window).height())
        $('#more_events').click() unless $('#more_events').first().css('display') == "none"
