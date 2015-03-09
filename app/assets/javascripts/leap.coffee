$ ->
  $("[title]").tooltip
    container: "body"
  show_sidebar = ->
    $('#sidebar').hide().removeClass("visible-lg visible-md").slideDown 'slow'
    $('.hidden-sidebar').hide('quick')
  hide_sidebar = ->
    $('#sidebar').slideUp
      duration: 'slow'
      complete: -> $(this).addClass("visible-lg visible-md").show()
    $('.hidden-sidebar').show('quick')
  $('#navbar-collapse').on 'show.bs.collapse', -> show_sidebar()
  $('#navbar-collapse').on 'hide.bs.collapse', -> hide_sidebar()
  $('#show-sidebar').click ->
    if $('#sidebar').hasClass('visible-lg') then show_sidebar() else hide_sidebar()
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
  $('[data-download-table]').click ->
    $($(this).attr('data-download-table')).tableExport
      type: $(this).attr('data-download-type')
      escape: $(this).attr('data-download-escape') or false
      htmlContent: true

 filterCourseList = (status) ->
    $("[data-course-person-filter]").removeClass("active")
    $("[data-course-person-filter=#{status}]").addClass("active")
    if status == "show-all"
      $("[data-mis-status]").show()
    else
      $("[data-mis-status]:not([data-mis-status=#{status}])").hide()
      $("[data-mis-status=#{status}]").show()

