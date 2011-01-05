class Event < ActiveRecord::Base

  validates :person_id,      :presence => true
  validates :event_date,     :presence => true
  validates :eventable_id,   :presence => true
  validates :eventable_type, :presence => true

  belongs_to :eventable, :polymorphic => true

  before_validation {|event| update_attribute("person_id", event.eventable.person_id)}

end
