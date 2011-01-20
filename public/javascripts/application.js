function open_extended_event(ev){
  ev = $(ev);
  Effect.SlideDown(ev.down('.extended'));
  ev.down('.close_extend_button').show();
  ev.down('.extend_button').hide();
}

function close_extended_event(ev){
  ev = $(ev);
  Effect.SlideUp(ev.down('.extended'));
  ev.down('.extend_button').show();
  ev.down('.close_extend_button').hide();
}

function refresh_event(ev,content){
  ev = $(ev);
  //Effect.SlideUp(ev.down('.attachments'));
  //new Ajax.Request("/events/" + ev.identify(), {
  //  method: 'get',
  //  onSuccess: function(transport){
  //    $(ev).replace(transport.responseText);
  //  }
  //})
  ev.replace(content);
  ev.fire("ajax:after");
}

document.observe("dom:loaded", function(){
  
  // Buttons for opening/closing extended sections of events
  $$('.extend_button').each(function(element){
    element.observe('ajax:complete',function(event){
      article = event.findElement('article')
      article.down('.extended .inner').update(event.memo.responseText);
      article.select('form[data-remote="true"]').each(function(form){
        init_new_target_form(form);
      })
      open_extended_event(article);
    })
  })
  $$('.close_extend_button').each(function(element){
    element.observe('click',function(event){
      article = event.findElement('article');
      close_extended_event(article);
    })
  })
})

// Submitting new target forms
function init_new_target_form(element){
  $(element).observe('ajax:complete', function(event){
    close_extended_event(event.findElement('article'));   
    refresh_event(event.findElement('article'),event.memo.responseText);
  })
}
