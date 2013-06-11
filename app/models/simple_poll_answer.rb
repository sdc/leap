class SimplePollAnswer < Eventable
  attr_accessible :answer, :created_by, :person_id, :simple_poll_id
  belongs_to :person
  belongs_to :simple_poll
end
