$ ->
  $('#cleap .delete-event')
    .on 'ajax:complete', ->
      $(this).closest('.event').hide("slow")
