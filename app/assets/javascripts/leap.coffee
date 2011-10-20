#TODO: Port this to jquery when I can see EBS!
#  $$('.timetable_event').each(function(e){
#    e.observe('mouseover', function(event){
#      event.findElement('.timetable_event').addClassName('extended')
#    })
#    e.observe('mouseout', function(event){
#      event.findElement('.timetable_event').removeClassName('extended')
#   })
#  })
#})
$(document).ready ->
  $('#person_photo>img')
    .load(-> $(this).fadeIn())
    .mouseover(-> $(this).effect('shake', {times:2,distance:3},100))
  $('#flash_notice').delay(4000).fadeOut()
  $('#q').focus();
  $('#search_extended').click( -> $('#search_form').submit())
  $('.tabs').tabs()
  $('#datepicker').datepicker({buttonImage:'/assets/timetable.png',dateFormat:'D dd M yy',altFormat:'yy-mm-dd',altField:'#real_datepicker'})
