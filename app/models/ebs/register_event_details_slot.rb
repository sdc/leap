class Ebs::RegisterEventDetailsSlot < Ebs::Model
  
  belongs_to :register_event
  belongs_to :register_event_slot
  delegate   :description, :to => :register_event
  delegate   :rooms, :teachers, :to => :register_event_slot

  def the_object
    case object_type 
    when "R": Ebs::Room.find(object_id)
    when "T": Ebs::Person.find(object_id)
    when "L": Ebs::Person.find(object_id)
    else throw "Not a known object"
    end
  end

  def usage
    Ebs::Usage.find_by_usage_code_and_object_type(usage_code,object_type)
  end

  def generic_mark
    usage ? usage.positive_for_ema : "-"
  end

end
