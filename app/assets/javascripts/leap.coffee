$(document).ready ->
  if $('.online_help').length == 0
    $('#help_button').hide()
  $('#person_photo>img')
    .load(-> $(this).fadeIn())
    .mouseover(-> $(this).effect('shake', {times:2,distance:3},100))
  $('#flash_notice').delay(4000).fadeOut('slow')
  $('#q').focus();
  $('#search_extended').click( -> $('#search_form').submit())
  $('.tabs').tabs()
  $('#datepicker').datepicker({buttonImage:'/assets/timetable.png',dateFormat:'D dd M yy',altFormat:'yy-mm-dd',altField:'#real_datepicker'})
  $('.timetable_event')
    .live('mouseover', -> $(this).addClass('extended'))
    .live('mouseout',  -> $(this).removeClass('extended'))
  $('.online_help').appendTo($('#help'))
  $('#help_button').click -> 
    $('.online_help').appendTo($('#help')).show()
    $('#help').height($(window).height()) 
    $('#help').toggle('slide', {direction:'right'})
    $('#help_button').toggleClass('hover')
  $(window).resize ->
    $('#help').height($(window).height())
  $('[load_block]').each (i,block) ->
    $(block).load $(block).attr('load_block'), ->
      $('.tabs').tabs()
      $('#help_button').show() unless $('.online_help').length == 0
      $('#progression_review_approved').change ->
        if($('#progression_review_approved').val() == "true")
          $('#progression_reviews_reason_div').hide('slow')
          $('#progression_reviews_conds_div').show('slow')
        else
          $('#progression_reviews_conds_div').hide('slow')
          $('#progression_reviews_reason_div').show('slow')
  $('#expand_students').live 'click', ->
    $('#students').children('.clearfix').css('height','auto')
    $('#expand_students').hide()
  $('#person_header_selector').change ->
    if ($('#person_header_selector option:selected').val())
      $('#event_header_spinner').show()
      $('#event_header').hide('fast')
      $('#event_header').load $('#person_header_selector option:selected').val(), ->
        $('.tabs').tabs()
        $('#event_header_spinner').hide()
        $('#event_header').show('fast')
    else
      $('#event_header').hide('fast', -> $('#event_header').empty())
