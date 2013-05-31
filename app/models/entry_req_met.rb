class EntryReqMet < Eventable

  attr_accessible :met, :entry_req_id, :no_but

  belongs_to  :entry_req

  after_save do |erm|
    if erm.met?
      erm.events.create(:transition => :complete)# if erm.events.creation.empty?
    else
      erm.events.create(:transition => :drop)# if erm.events.drop.empty?
    end
  end

  def status
    if met?
      no_but.blank? ? :complete : :current
    else
      :incomplete
    end
  end

end
