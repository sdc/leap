$ ->
  $('#cleap .delete-event').on 'ajax:complete', ->
    $(this).closest('.tile').hide("slow")
  show_clidebar = ->
    $('#clidebar').hide().removeClass("visible-lg visible-md").slideDown 'slow'
    $('.hidden-clidebar').hide('quick')
  hide_clidebar = ->
    $('#clidebar').slideUp
      duration: 'slow'
      complete: -> $(this).addClass("visible-lg visible-md").show()
    $('.hidden-clidebar').show('quick')
  $('#navbar-collapse').on 'show.bs.collapse', -> show_clidebar()
  $('#navbar-collapse').on 'hide.bs.collapse', -> hide_clidebar()
  $('#show-clidebar').click ->
    if $('#clidebar').hasClass('visible-lg') then show_clidebar() else hide_clidebar()
  $('.tile [data-link]').each (i,e) ->
    $(e).closest('.tile').attr('data-link',$(e).attr('data-link'))
  $('.tile[data-link]').click ->
    document.location = $(this).attr('data-link')
