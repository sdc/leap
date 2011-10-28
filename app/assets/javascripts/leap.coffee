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
  $('#help_button').click -> $('#help').toggle('slide', {direction:'vertical'})
