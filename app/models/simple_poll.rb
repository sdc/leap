class SimplePoll < ActiveRecord::Base
  attr_accessible :answers, :question
  serialize :answers
end
