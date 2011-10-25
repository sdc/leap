$(document).ready ->
  unless $('#events') == []
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
    $('.close_extend_button').live 'click', (event) ->
      e = $(event.target).closest('.event')
      e.find('.extended').slideUp()
      e.find('.extend_button').show()
      e.find('.close_extend_button').hide()
    $('form.event_update_form').live 'ajax:complete', (event,data) ->
      e = $(event.target).closest('.event')
      e.replaceWith(data.responseText)
    $('#more_events').click ->
      $('#more_events').hide()
      $('#more_events_loading').show()
    $('#more_events').live 'ajax:complete', (event,data) ->
      unless data.responseText.length == 1
        $('#events').append innerShiv data.responseText
        d = $('#events').children('.event').last().find('time').attr('datetime')
        url = $('#more_events').attr('href').replace(/([&\?])date=[^&]*/,"$1date="+d)
        $('#more_events').attr('href',url).show()
      $('#more_events_loading').hide()
    $(window).scroll ->
      if ($(window).scrollTop() == $(document).height() - $(window).height())
        $('#more_events').click() unless $('#more_events').first().css('display') == "none"
