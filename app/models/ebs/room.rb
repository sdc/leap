class Ebs::Room < Ebs::Model

  has_many "register_event_details",
           :conditions  => "object_type = 'R'",
           :foreign_key => "object_id"
  has_many "register_event_details_slots",
           :conditions  => "object_type = 'R'",
           :foreign_key => "object_id"

end
