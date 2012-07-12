###
leap.coffee
The general js needed for leap stuff
###
$(document).ready ->
  # Fade in the person photo once it's loaded  
  $('.person-photo>img')
    .load(-> $(this).fadeIn())
    .mouseover(-> $(this).effect('shake', {times:2,distance:3},100))

  #Init Popovers
  $(".has-popover").popover()

  # Fade out notices after a while
  #$('#flash_notice').delay(4000).fadeOut('slow')

  # Focus on any input field with id 'q'. Usually used to focus the search box
  $('#q').focus()

  # Submit the search form if you press the extended search link
  $('#search_extended').click( -> $('#search_form').submit())

  # Set up a date picker for timetables
  $('.timetable-datepicker').datepicker({buttonImage:'/assets/timetable.png',dateFormat:'D dd M yy',altFormat:'yy-mm-dd',altField:'#real_datepicker'})

  # Show extended info on timetable events on mouseover
  $('.timetable_event')
    .live('mouseover', -> $(this).addClass('extended'))
    .live('mouseout',  -> $(this).removeClass('extended'))

  # Don't show the help button if there is no help on this page.
  if $('.online-help').length == 0
    $('#help_button').hide()

  # Build the online help by concatinating any info wrapped in a div with class "online-help"
  $('.online-help').appendTo($('#help'))

  # Open the help panel when you click the help button - make it full window height
  $('#help_button').click -> 
    $('.online-help').appendTo($('#help')).show()
    $('#help').height($(window).height()) 
    $('#help').toggle('slide', {direction:'right'})
    $('#help_button').toggleClass('hover')

  # Keep help panel at full window height on window resize
  $(window).resize ->
    $('#help').height($(window).height())

  # Load the blocks on home pages
  $('[load_block]').each (i,block) ->
    $(block).load $(block).attr('load_block'), ->
      $('#help_button').show() unless $('.online-help').length == 0
      # TODO: This needs to be moved into a seperate file to keep events seperate if I can hook it into 
      #       the loading of the create form
      $('#progression_review_approved').change ->
        if($('#progression_review_approved').val() == "true")
          $('#progression_reviews_reason_div').hide('slow')
          $('#progression_reviews_conds_div').show('slow')
        else
          $('#progression_reviews_conds_div').hide('slow')
          $('#progression_reviews_reason_div').show('slow')

  # Expand the class list on class pages
  $('#expand_students').live 'click', ->
    $('#students').children('.clearfix').css('height','auto')
    $('#expand_students').hide()

  # Drop down list to select the student on course-level event creation
  $('#person_header_selector').change ->
    if ($('#person_header_selector option:selected').val())
      $('#event_header_spinner').show()
      $('#event_header').hide('fast')
      $('#event_header').load $('#person_header_selector option:selected').val(), ->
        $('#event_header_spinner').hide()
        $('#event_header').show('fast')
    else
      $('#event_header').hide('fast', -> $('#event_header').empty())
