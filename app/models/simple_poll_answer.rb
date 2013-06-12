class SimplePollAnswer < Eventable

  attr_accessible :answer, :created_by, :person_id, :simple_poll_id

  belongs_to :person
  belongs_to :simple_poll

  delegate :question, :results, :to => :simple_poll

  after_create {|ans| ans.events.create!(:event_date => created_at, :transition => :create)}

  def extra_panes
    [["Results","events/tabs/simple_poll_answer"]]
  end

end
