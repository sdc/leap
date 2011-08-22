class Review < Eventable

  belongs_to :review_window
  belongs_to :person
  has_many   :review_lines, :dependent => :destroy

  delegate :start_date, :to => :review_window
  delegate :end_date,   :to => :review_window

  after_create {|review| review.events.create!(:event_date => created_at, :transition => :hidden)}
  after_create :create_review_lines

  def body_partial 
    true
  end

  def title
    review_window.name
  end

  def create_review_lines
    a = person.timetable_events(:from => start_date, :to => end_date)
    a.each do |l|
      next if review_lines.detect{|la| la.mis_id == l.id}
      review_lines.create(:person_id => person.id, :mis_id => l.mis_id, :title => l.title, :teachers => l.teachers.map{|t| t.id})
    end
  end

end
