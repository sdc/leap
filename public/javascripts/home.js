document.observe("dom:loaded", function(){
  $('next_lesson').observe("click", function(event){
    window.location = $('next_lesson').down('a').href
  })
})
