class Disciplinary < Eventable

  validates :body, :presence => true
  validates :level, :presence => true, :numericality => true, :inclusion => {:in => 0..3}

  after_create {|disciplinary| disciplinary.events.create!(:event_date => created_at, :transition => :create)}

  # Returns the note eventable  Title. This is always the same.
  def title
    case level
      when 0
        "Amber Alert"
      when 1
        "Positive Intervention Stage One"
      when 2
        "Positive Intervention Stage Two"
      when 3
        "Positive Intervention Stage Three"
    end
  end

end
