document.observe("dom:loaded", function(){
  if ($('next_lesson')) {
    $('next_lesson').observe("click", function(event){
      window.location = $('next_lesson').down('a').href
    })
  }
})
