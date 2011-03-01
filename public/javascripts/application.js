function open_extended_event(ev){
  ev = $(ev);
  Effect.SlideDown(ev.down('.extended'), {queue: 'end'});
  ev.down('.close_extend_button').show();
  ev.down('.extend_button').hide();
}

function close_extended_event(ev){
  ev = $(ev);
  Effect.SlideUp(ev.down('.extended'), {queue: 'end'});
  ev.down('.extend_button').show();
  ev.down('.close_extend_button').hide();
}

function watch_events(e){  
  // Buttons for opening/closing extended sections of events
  $(e).select('.extend_button[observer="false"]').each(function(element){
    element.writeAttribute("observer","true");
    element.observe('ajax:complete',function(event){
      article = event.findElement('.event')
      article.down('.extended .inner').update(event.memo.responseText);
      article.select('form[data-remote="true"]').each(function(form){
        init_new_target_form(form);
      })
      open_extended_event(article);
    })
  })
  $(e).select('.close_extend_button[observer="false"]').each(function(element){
    element.writeAttribute("observer","true");
    element.observe('click',function(event){
      article = event.findElement('.event');
      close_extended_event(article);
    })
  })
}

function watch_main_pane_updaters(e){
  $(e).select('.ajax_update_main_pane').each(function(element){
    element.observe('ajax:complete', function(event){
      $('main_pane').update(event.memo.responseText);
      watch_events("events");
      watch_main_pane_updaters(e);
    })
  })
}

// Submitting new target forms
function init_new_target_form(element){
  $(element).observe('ajax:complete', function(event){
    close_extended_event(event.findElement('.event'));   
    the_id = article.identify();
    event.findElement('.event').replace(event.memo.responseText);
    watch_events(the_id);
  })
}

document.observe("dom:loaded", function(){
  watch_events("events");
  watch_main_pane_updaters("main_container");
  $('more_events').observe('ajax:complete', function(event){
    $('events').insert(event.memo.responseText);
    watch_events("events");
  })
  $('person_photo').down('img').observe("load", function(){
    event.findElement('img').appear();
  })
})

