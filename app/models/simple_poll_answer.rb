class SimplePollAnswer < Eventable

  attr_protected
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :person
  belongs_to :simple_poll

  validates :person_id, :uniqueness => {:scope => :simple_poll_id}
  validates :answer, :inclusion => {:in => proc { |x| x.simple_poll.answers}}

  delegate :question, :results, :to => :simple_poll

  # after_create {|ans| ans.events.create!(:event_date => created_at, :transition => :create)}

  def strong_params_validate
  	[{:event_date => self.created_at, :transition => :create}]
  end  

  def extra_panes
    [["Results","events/tabs/simple_poll_answer"]]
  end

end
