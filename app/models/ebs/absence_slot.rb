class Ebs::AbsenceSlot < Ebs::Model

  attr_protected
  include ActiveModel::ForbiddenAttributesProtection	

  belongs_to :absence, :dependent => :destroy, :counter_cache => true
  belongs_to :register_event_details_slot

  self.table_name= "sdc_ilp_absence_slots"

end
