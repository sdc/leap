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
  $(e).select('.extend_button').each(function(element){
    element.observe('ajax:complete',function(event){
      article = event.findElement('article')
      article.down('.extended .inner').update(event.memo.responseText);
      article.select('form[data-remote="true"]').each(function(form){
        init_new_target_form(form);
      })
      open_extended_event(article);
    })
  })
  $(e).select('.close_extend_button').each(function(element){
    element.observe('click',function(event){
      article = event.findElement('article');
      close_extended_event(article);
    })
  })
}

// Submitting new target forms
function init_new_target_form(element){
  $(element).observe('ajax:complete', function(event){
    close_extended_event(event.findElement('article'));   
    the_id = article.identify();
    event.findElement('article').replace(event.memo.responseText);
    watch_events(the_id);
  })
}

document.observe("dom:loaded", function(){
    watch_events("events");
    $('more_events').observe('ajax:complete', function(event){
      $('events').insert(event.memo.responseText);
    })
})

