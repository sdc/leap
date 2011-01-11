# = Event
#
# This class handles all the abstracted behaviour that a good event should implement. It's here so that we can 
# treat all events polymorphically. All the real work is done in the model for the actual event type that
# we call an eventable. Examples include Target and Note. Events are never created directly, 
# this should be done by the eventable.
#
# Event implements four methods which all do pretty much the same thing. title, +subtitle+, +icon_url+ and +body+ each call
# an identically named method, if it exists, in the eventable. If the method in the eventable takes an argument it will be
# passed the event_date from the Event. This allows the eventable to return different information depending on when the
# event happened. This is how Target eventables return different event information before and after their completion date,
# for example.
#
# == Useful Scopes
#
# +backwards+::        Orders the events by reverse +event_date+.
# +from_to(from,to)+:: Finds the events between the dates _from_ and _to_.

class Event < ActiveRecord::Base

  validates :person_id,      :presence => true
  validates :event_date,     :presence => true
  validates :eventable_id,   :presence => true
  validates :eventable_type, :presence => true

  scope :backwards, order("event_date DESC")
  scope :from_to, lambda {|from,to| where(:event_date => from..to)}

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
