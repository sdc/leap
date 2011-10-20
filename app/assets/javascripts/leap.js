  //$('person_photo').down('img').observe("load", function(event){
  //  event.findElement('img').appear();
  //)
//TODO: Port this to jquery when I can see EBS!
//  $$('.timetable_event').each(function(e){
//    e.observe('mouseover', function(event){
//      event.findElement('.timetable_event').addClassName('extended')
//    })
//    e.observe('mouseout', function(event){
//      event.findElement('.timetable_event').removeClassName('extended')
//    })
//  })
//})
$(document).ready(function(){
  $('#flash_notice').delay(4000).fadeOut();
  $('#person_photo').mouseover(function(){
    $('#person_photo').effect('shake', { times:2,distance:3}, 100);
  })
  $('#q').focus();
  $('#search_extended').click(function(){$('#search_form').submit()});
  $('#person_photo>img').load(function(event){$(event.target).fadeIn()});
})
