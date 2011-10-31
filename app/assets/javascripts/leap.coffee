$(document).ready ->
  $('#person_photo>img')
    .load(-> $(this).fadeIn())
    .mouseover(-> $(this).effect('shake', {times:2,distance:3},100))
  $('#flash_notice').delay(4000).fadeOut()
  $('#q').focus();
  $('#search_extended').click( -> $('#search_form').submit())
  $('.tabs').tabs()
  $('#datepicker').datepicker({buttonImage:'/assets/timetable.png',dateFormat:'D dd M yy',altFormat:'yy-mm-dd',altField:'#real_datepicker'})
  $('.timetable_event')
    .live('mouseover', -> $(this).addClass('extended'))
    .live('mouseout',  -> $(this).removeClass('extended'))
  $('#help_button').click -> 
    $('#help').height($(window).height()) 
    $('#help').toggle('slide', {direction:'right'})
    $('#help_button').toggleClass('hover')
  $(window).resize ->
    $('#help').height($(window).height())
  $('[load_block]').each (i,block) ->
    $(block).load $(block).attr('load_block'), ->
      $('.tabs').tabs()
  $('#expand_students').live 'click', ->
    $('#students').children('.clearfix').css('height','auto')
    $('#expand_students').hide()
  $('#person_header_selector').change ->
    if ($('#person_header_selector option:selected').val())
      $('#event_header_spinner').show()
      $('#event_header').hide()
      $('#event_header').load $('#person_header_selector option:selected').val(), ->
        $('.tabs').tabs()
        $('#event_header').show()
        $('#event_header_spinner').hide()
    else
      $('#event_header').empty()
