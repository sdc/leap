class Eventable < ActiveRecord::Base

  self.abstract_class = true

  belongs_to :person, :dependent => :destroy
  belongs_to :created_by, :foreign_key => "created_by_id", :class_name => "Person", :dependent => :destroy
  has_many :events, :as => :eventable, :dependent => :destroy

  before_validation {|e| update_attribute("created_by_id", Person.user.id)}

  validates :person_id, :presence => true

  def icon_url
    "events/#{self.class.name.tableize}.png"
  end

  def title
    self.class.name.underscore.humanize.titleize
  end

end
