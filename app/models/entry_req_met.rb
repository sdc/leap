class EntryReqMet < Eventable

  attr_accessible :body, :status

  belongs_to  :entry_req

  after_save do |erm|
    if erm.met?
      erm.events.create(:transition => :complete)# if erm.events.creation.empty?
    else
      erm.events.create(:transition => :drop)# if erm.events.drop.empty?
    end
  end

end
