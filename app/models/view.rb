class View < ActiveRecord::Base

  serialize :transitions
  serialize :events
  serialize :affiliations
  serialize :controls

  def to_param
    name
  end

end
