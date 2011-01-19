document.observe("dom:loaded", function(){
  $$('.extend_button').each(function(element){
    element.observe('ajax:complete',function(event){
      article = event.findElement('article')
      article.down('.extended .inner').update(event.memo.responseText);
      Effect.SlideDown(article.down('.extended'));
      article.down('.close_extend_button').show();
      article.down('.extend_button').hide();
    })
  })
  $$('.close_extend_button').each(function(element){
    element.observe('click',function(event){
      article = event.findElement('article');
      Effect.SlideUp(article.down('.extended'));
      article.down('.extend_button').show();
      article.down('.close_extend_button').hide();
    })
  })
})
