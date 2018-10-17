class Ebs::AbsenceSlot < Ebs::Model

  belongs_to :absence, :dependent => :destroy, :counter_cache => true, :foreign_key => "absence_id"
  belongs_to :register_event_details_slot

  attr_accessible :absence_id, :register_event_details_slot_id

  self.table_name= "sdc_ilp_absence_slots"

  self.primary_key= "id"

end
