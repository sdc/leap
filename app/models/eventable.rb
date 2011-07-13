class Eventable < ActiveRecord::Base

  self.abstract_class = true

  belongs_to :person, :dependent => :destroy
  has_many :events, :as => :eventable, :dependent => :destroy
  validates :person_id, :presence => true

  def icon_url
    "events/#{self.class.name.tableize}.png"
  end

  def title
    self.class.name.humanize.titleize
  end

end
