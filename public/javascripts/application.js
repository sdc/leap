document.observe("dom:loaded", function(){
  $$('.extend_button').each(function(element){
    element.observe('ajax:complete',function(event){
      event.findElement('article').down('.extended .inner').update(event.memo.responseText);
      Effect.SlideDown(event.findElement('article').down('.extended'));
    })
  })
})
