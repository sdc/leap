document.observe("dom:loaded", function(){
  watch_main_pane_updaters("main_container");
  if ($('q')) {
    $('q').activate();
    if ($('search_extended')) {
      $('search_extended').observe("click", function(event){
        $('search_form').submit();
      })
    }
  }
  $('person_photo').down('img').observe("load", function(event){
    event.findElement('img').appear();
  })
  $('person_photo').down('img').observe("mouseover", function(event){
    event.findElement('img').shake({distance : 2});
  })
  $$('.timetable_event').each(function(e){
    e.observe('mouseover', function(event){
      event.findElement('.timetable_event').addClassName('extended')
    })
    e.observe('mouseout', function(event){
      event.findElement('.timetable_event').removeClassName('extended')
    })
  })
})
