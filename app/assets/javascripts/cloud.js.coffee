$ ->
  $('#cleap .delete-event')
    .on 'click', ->
      alert("Clicked")
    .on 'ajax:success', ->
      $(this).closest('.event').hide()
