class MeetingOutcome < Eventable

  attr_protected
  include ActiveModel::ForbiddenAttributesProtection
	
  # attr_accessible :body, :created_by_id, :person_id, :title
end
