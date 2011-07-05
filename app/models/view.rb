class View < ActiveRecord::Base

  serialize :transitions
  serialize :events
  serialize :affiliations

  def to_param
    name
  end

end
