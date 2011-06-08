class Attendance < ActiveRecord::Base

  has_many :events, :as => :eventable, :dependent => :destroy
  belongs_to :person
  #scope order(:week_beginning)

  after_create do |attendance|
    attendance.events.create!(:event_date => week_beginning, :transition => :complete)
  end

  def icon_url
    "events/attendance.png" 
  end

  def title
    "Weekly Attendance"
  end

  def status
    :complete
  end

  def subtitle
    "#{att_week}%"
  end

  def body
    "Attendance this week: #{att_week}%, overall: #{att_year}"
  end

end
