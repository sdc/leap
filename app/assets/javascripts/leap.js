//document.observe("dom:loaded", function(){
//  if ($('flash_notice')){
//    Element.fade.delay(4,'flash_notice');
//  }
//  if ($('q')) {
//    $('q').activate();
//    if ($('search_extended')) {
//      $('search_extended').observe("click", function(event){
//        $('search_form').submit();
//      })
//    }
//  }
  //$('person_photo').down('img').observe("load", function(event){
  //  event.findElement('img').appear();
  //)
//  $('person_photo').down('img').observe("mouseover", function(event){
//    event.findElement('img').shake({distance : 2});
//  })
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
})
