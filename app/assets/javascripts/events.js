$(document).ready(function(){
  watch_events('#events');
  watch_more_events();
})

function open_extended_event(ev){
  ev = $(ev);
  ev.find('.extended').slideDown();
  ev.find('.close_extend_button').show();
  ev.find('.extend_button').hide();
}
function close_extended_event(ev){
  ev = $(ev);
  ev.find('.extended').slideUp();
  ev.find('.close_extend_button').hide();
  ev.find('.extend_button').show();
}

function watch_events(e){
  $(e).find('.extend_button').live('ajax:complete',function(event,xhr){
    article=$(event.target).closest('.event')
    article.find('.extended .inner').replaceWith(xhr.responseText);
    open_extended_event(article);
  })
  $(e).find('.close_extend_button').live('click',function(event){
    article = $(event.target).closest('.event')
    close_extended_event(article);
  })
}
function watch_more_events(){
  $('#more_events').click(function(event){
    $('#more_events').hide();
    $('#more_events_loading').show();
  });
  $('#more_events').live('ajax:complete',function(event,xhr){
    //$('#more_events_loading').hide();
    $('#events').append(xhr.responseText);
    if (xhr.responseText==" "){
      $('#more_events_loading').fadeOut();
      $('#events').append("There are no more events...");
    }else{
      d=$('#events').children().last().find('time').attr('datetime');
      url = $('#more_events').attr('href').replace(/&date=[^&]*/,"&date="+d);
      $('#more_events').attr('href',url).show();
      $('#more_events_loading').hide();
    }
  })
}
//// Submitting new target forms
//function init_new_target_form(element){
//  $(element).observe('ajax:complete', function(event){
//    close_extended_event(event.findElement('.event'));   
//    the_id = article.identify();
//    event.findElement('.event').replace(event.memo.responseText);
//    watch_events(the_id);
//  })
//}
