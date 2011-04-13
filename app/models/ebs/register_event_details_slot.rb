class Ebs::RegisterEventDetailsSlot < Ebs::Model
  
  TT_PPS = 40
  
  #belongs_to :register_event_detail
  #belongs_to :register_event_slot
  belongs_to :register_event
  delegate :description, :to => :register_event
  #has_one    :absence_slot
  #has_one    :absence, :through => :absence_slot

  #belongs_to :room,
  #           :conditions  => "object_type = 'R'",
  #           :foreign_key => "object_id"
  #belongs_to :teacher,
  #           :class_name  => "Person",
  #           :foreign_key => "object_id",
  #           :conditions  => "object_type = 'T'"
  #belongs_to :learner,
  #           :class_name  => "Person",
  #           :foreign_key => "object_id"
  #belongs_to :course,
  #           :conditions  => "object_type = 'U'",
  #           :foreign_key => "object_id"


  USAGES = { "/" => "present",
             "A" => "ac_absence",
             "L" => "late",
             "E" => "left_early",
             "0" => "absent",
             "O" => "absent",
             "K" => "known_ab",
	     "C" => "completed",
             "-" => "na"
           }

  ENGLISH_USAGES = 
           { "/" => "present",
             "A" => "academic absence",
             "L" => "late",
             "E" => "left early",
             "0" => "absent",
             "O" => "absent",
             "K" => "notified absence",
	     "C" => "completed",
             "-lp" => "no lesson"
           }

  def timetable_margin
    50 + ((planned_start_date - planned_start_date.change(:hour => 8,:minute => 0, :sec => 0, :usec => 0)) / TT_PPS).floor 
  end

  def timetable_width
    ((planned_end_date - planned_start_date) / TT_PPS).floor
  end

  def mindec
    (planned_start_date.min / 10).to_i
  end

  def mindecs
    ((planned_end_date - planned_start_date) / 600).to_i
  end

  def timetable_class
    if object_type == "T"
      return "teaching"
    elseif object_type == "I"
      return "interview"
    else
      return USAGES.include?(usage_code) ? USAGES[usage_code] : "dunno"
    end
  end

  def glh
    (planned_end_date - planned_start_date) / 3600
  end

  def english_usage
    ENGLISH_USAGES[usage_code] or "empty"
  end

end
