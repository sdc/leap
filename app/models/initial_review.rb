class InitialReview < Eventable
  attr_accessible :body, :created_at, :created_by_id, :progress_id, :target_grade

  belongs_to :progresses, :foreign_key => "progress_id"
  before_save :set_values

  after_create do |line|
    #line.events.create!(:event_date => created_at, :transition => :create, :person_id => person_id)
  end

  def set_values
  	self.created_at ||= Time.now
  	self.created_by_id ||= Person.user.id
  end

end
