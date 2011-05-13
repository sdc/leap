class TimetableEvent < SuperModel::Base

  def timetable_margin
   ((start - start.change(:hour => 8,:minute => 0, :sec => 0, :usec => 0)) / 50).floor 
  end

  def timetable_height
    ((self.end - start) /50).floor
  end

  def css_class
    mark
  end

end
