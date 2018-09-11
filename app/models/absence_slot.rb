class AbsenceSlot < ActiveRecord::Base

  belongs_to :absence, :dependent => :destroy, :counter_cache => true
  belongs_to :register_event_details_slot

end
