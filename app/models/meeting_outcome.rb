class MeetingOutcome < Eventable
	
  def accessible_attributes
    return ['body', 'created_by_id', 'person_id', 'title']
  end

end
