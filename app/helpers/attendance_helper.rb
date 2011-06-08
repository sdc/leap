module AttendanceHelper

  def attendance_graph(attendances)
    "https://chart.googleapis.com/chart?" +
    "chs=200x48&cht=lc&chco=0077CC&chf=bg,s,00000000&chd=t:" +
    attendances.map{|a| a.att_year}.join(',')
  end

end
