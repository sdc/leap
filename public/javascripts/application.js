function watch_main_pane_updaters(e){
  $(e).select('.ajax_update_main_pane').each(function(element){
    element.observe('ajax:before', function(event){
      $('main_pane').hide();
    })
    element.observe('ajax:complete', function(event){
      $('main_pane').update(event.memo.responseText);
      watch_events("events");
      watch_main_pane_updaters(e);
      $('main_pane').appear();
    })
  })
}

document.observe("dom:loaded", function(){
  watch_main_pane_updaters("main_container");
  $('person_photo').down('img').observe("load", function(event){
    event.findElement('img').appear();
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
