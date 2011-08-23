class Attendance < Eventable

  default_scope :order => 'week_beginning'

  after_create do |attendance|
    attendance.events.create!(:event_date => week_beginning, :transition => :complete)
  end

  def title
    "Weekly Attendance"
  end

  def status
    if att_year > 89
      :complete
    elsif att_year > 84
      :start
    else
      :overdue
    end
  end

  def subtitle
    "#{att_year}%"
  end

  def body_partial
    true
  end

end
