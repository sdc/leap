class Ebs::RegisterEventSlot < Ebs::Model

  set_table_name "register_event_slots"

  belongs_to :register_event
  has_many   :register_event_details_slots

  def rooms
    register_event_details_slots.where(:object_type => "R").map{|d| d.the_object}
  end

  def teachers
    register_event_details_slots.where(:object_type => "T").map{|d| d.the_object}
  end

  def learners
    register_event_details_slots.where(:object_type => "L").map{|d| d.the_object}
  end

end
