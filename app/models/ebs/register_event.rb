class Ebs::RegisterEvent < Ebs::Model

  has_many :register_event_details_slots
  #has_many :register_event_slots
  #has_many   :rooms, 
         #    :through => :register_event_details
  #has_many   :learners, 
	#     :through => :register_event_details
  #has_many   :teachers,
   #          :through => :register_event_details
  #has_one    :course, 
   #          :through => :register_event_details
  #belongs_to :session, :foreign_key => "session_code"

  def long_description
    starty = register_event_slots.first.startdate
    "#{description} (#{Date::ABBR_DAYNAMES[starty.wday]} #{starty.hour}.#{starty.min})"
  end
  
  def count_learners
    learners.size
  end

  def this_year?
    session.now?
  end

end
