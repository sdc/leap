class Tile

  include ActiveModel::Conversion

  attr_accessor :id, :title, :bg, :icon, :is_deletable, :subtitle, :body, :person_id, :event_id

  def initialize(attrs)
    attrs.each {|a| send("#{a.first}=", a.last) if respond_to?("#{a.first}=")}
  end

  def person
    Person.find person_id
  end

  def event
    Event.find event_id
  end

  def is_deletable?; is_deletable end

  def persisted?; false end

end
