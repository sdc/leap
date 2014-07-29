$ ->
  $('#cleap .delete-event').on 'ajax:complete', ->
    $(this).closest('.tile').hide("slow")
