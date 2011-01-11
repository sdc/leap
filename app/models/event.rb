class Event < ActiveRecord::Base

  validates :person_id,      :presence => true
  validates :event_date,     :presence => true
  validates :eventable_id,   :presence => true
  validates :eventable_type, :presence => true

  delegate :icon_url, :body, :to => :eventable

  belongs_to :eventable, :polymorphic => true

  before_validation {|event| update_attribute("person_id", event.eventable.person_id)}

  def title
    eventable.title(event_date)
  end

  def subtitle
    eventable.respond_to?("subtitle") ? eventable.subtitle(event_date) : nil
  end

end
