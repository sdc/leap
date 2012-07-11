###
events.coffee
All the stuff needed for the timeline to work properly
###

$(document).ready ->

  # Don't bother doing any of this if there's no events on the page
  unless $('#events') == []

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
        e.find('.datepicker').datepicker({buttonImage:'/assets/timetable.png',dateFormat:'D dd M yy'})#,altFormat:'yy-mm-dd',altField:'#real_datepicker'})
      .live 'click', (event) ->
        e = $(event.target).closest('.event')
        e.find('.event-spinner').show()
        e.find('.extend-button').hide()
    
    # Close the extended pane of an event
    $('.close-extend-button').live 'click', (event) ->
      e = $(event.target).closest('.event')
      e.find('.extended').slideUp()
      e.find('.extend-button').show()
      e.find('.close-extend-button').hide()
    
    # Spinner for deleting an event
    $('.delete-event-button').live 'click', (event) ->
      e = $(event.target).closest('.event')
      e.find('.event-spinner').show()
      e.find('.delete-event-button').hide()

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
