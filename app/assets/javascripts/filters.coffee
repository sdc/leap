angular.module 'leapApp'

.filter 'academicYear', ->
  (d) ->
    date = new Date(d)
    year = date.getFullYear()
    if date.getMonth() >= 9
      String(year).substring(2) + "/" + String(year + 1).substring(2)
    else
      String(year - 1).substring(2) + "/" + String(year).substring(2)

.filter 'simpleFormat', ->
  (t) ->
    return t.replace(/\n\n/,"<br /><br />")
