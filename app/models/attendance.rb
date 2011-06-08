class Attendance < ActiveRecord::Base

  has_many :events, :as => :eventable, :dependent => :destroy
  belongs_to :person
  default_scope :order => 'week_beginning'

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
    "<img src='https://chart.googleapis.com/chart?" +
    "chs=200x48&cht=ls&chco=0077CC&chf=bg,s,00000000&chd=t:" +
    person.attendances.select{|a| a.week_beginning < week_beginning}.map{|a| a.att_year}.join(',') +
    "' />" +
    "<dl><dt>This week:</dt><dd>#{att_week}%</dd><dt>Last three weeks:</dt><dd>#{att_3_week}%</dd></dl>"
  end

end
