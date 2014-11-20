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
  $('#show_weekend').click ->
    $('.monday,.tuesday').hide()
    $('.weekend').show()
    $('#show_weekend').hide()
    $('#hide_weekend').show()
  $('#hide_weekend').click ->
    $('.monday,.tuesday').show()
    $('.weekend').hide()
    $('#show_weekend').show()
    $('#hide_weekend').hide()
  $('#tutorgroup_id').change ->
    document.location = $('#tutorgroup_id').val()
  $('[data-row-hide]').click ->
    $($(this).attr('data-row-hide')).toggleClass("visible-lg")
  $('#course-home-tabs a').on 'shown.bs.tab', (e) -> 
    $.cookie "course-home-tabs",$(e.target).attr('href'), {expires: 365}
  $("#course-home-tabs a[href=#{$.cookie('course-home-tabs')}]").tab('show')
  $('[data-course-person-filter]').click ->
    filterCourseList $(this).attr('data-course-person-filter')

 filterCourseList = (status) ->
    $("[data-course-person-filter]").removeClass("active")
    $("[data-course-person-filter=#{status}]").addClass("active")
    if status == "show-all"
      $("[data-mis-status]").show()
    else
      $("[data-mis-status]:not([data-mis-status=#{status}])").hide()
      $("[data-mis-status=#{status}]").show()

