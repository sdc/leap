@fixCol1 = (tablename) ->
	jQuery("##{tablename}.table-scroll-main").clone(true).appendTo("#scroll-#{tablename}").addClass('table-scroll-clone').removeClass('table-scroll-main')
	jQuery("##{tablename}.table-scroll-clone[id],##{tablename}.table-scroll-clone [id]").each ->
		$(this).attr 'id', $(this).attr('id') + '-clone'
		return
	return