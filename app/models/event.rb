class Event < ActiveRecord::Base

  validates :person_id,      :presence => true
  validates :event_date,     :presence => true
  validates :eventable_id,   :presence => true
  validates :eventable_type, :presence => true

  belongs_to :eventable, :polymorphic => true

  before_validation {|event| update_attribute("person_id", event.eventable.person_id)}

  [:title,:subtitle,:icon_url,:body].each do |method|
    define_method method do
      if eventable.respond_to?(method) 
        m = eventable.method(method)
        if m.arity == 1
          m.call(event_date)
        else
          m.call
        end
      end
    end
  end

end
