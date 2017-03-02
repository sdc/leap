class InitialReview < Eventable
  attr_accessible :body, :created_at, :created_by_id, :progress_id, :target_grade

  validate :check_unique
  belongs_to :person, :foreign_key => "created_by_id"
  belongs_to :progress, :foreign_key => "progress_id"
  before_save :set_values

  after_create do |line|
    line.events.create!(:event_date => created_at, :transition => :create, :person_id => person_id)
  end

  def set_values
  	self.created_at ||= Time.now
  	self.created_by_id ||= Person.user.id
  end

  def status
    return :complete
  end

  def icon_class
    "fa-clipboard"
  end

  def check_unique
    if InitialReview.exists? ["progress_id = ? AND id != ?", self.progress_id, self.id]
      self.errors.add(:progress_id, 'Error, please contact IT')
    end
  end

  def pretty_created_at
    return self.created_at.to_formatted_s(:long)
  end

  def pretty_body
    return self[:body].empty? ? 'No comments' : self[:body]
  end

end
