class View < ActiveRecord::Base

  serialize :transitions
  serialize :events
  serialize :affiliations
  serialize :controls

  scope :affiliation, lambda {|aff| {:conditions => ["affiliations like ?", "%#{aff}%"]}}

  def to_param
    name
  end

end
