$ ->
  $('#cleap .delete-event').on 'ajax:complete', ->
    $(this).closest('.tile').hide("slow")
  #$('#cleap .event')
  #  .mouseenter -> $(this).closest('.event').addClass("event-highlight")
  #  .mouseleave -> $(this).closest('.event').removeClass("event-highlight")
