class Qualification < Eventable

  include MisQualification

  after_create {|qual| qual.events.create!(:event_date => created_at, :transition => :create)}

  def body
    self[:title]
  end

  def subtitle
    grade
  end

end
