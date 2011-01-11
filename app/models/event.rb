class Event < ActiveRecord::Base

  validates :person_id,      :presence => true
  validates :event_date,     :presence => true
  validates :eventable_id,   :presence => true
  validates :eventable_type, :presence => true

  [:title,:subtitle,:icon_url,:body].each do |method|
    define_method method do
      if eventable.respond_to?(method) 
        if eventable.method(method).arity == 1
          eventable.send(method,event_date)
        else
          eventable.send(method)
        end
      else
        nil
      end
    end
  end

  belongs_to :eventable, :polymorphic => true

  before_validation {|event| update_attribute("person_id", event.eventable.person_id)}

end
