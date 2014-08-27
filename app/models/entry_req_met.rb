class EntryReqMet < Eventable

  attr_accessible :met, :entry_req_id, :no_but

  belongs_to  :entry_req

  after_save do |erm|
    if erm.met?
      erm.events.find_or_create_by_transition(:complete) 
    else
      erm.events.find_or_create_by_transition(:drop) 
    end
  end

  def status
    met? ? :complete : :incomplete
  end

  def title
    ["Entry Req.", met ? "Met" : "Not Met"]
  end

end
