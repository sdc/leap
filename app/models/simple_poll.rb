class SimplePoll < ActiveRecord::Base
  attr_accessible :answers, :question
  serialize :answers
  has_many :simple_poll_answers

  def results
    simple_poll_answers.group("answer").count.sort{ |a,b| b.last <=> a.last }
  end

  def to_tile
    Tile.new({title: "Poll",
              bg: "9d9",
              icon: "fa-pie-chart",
              partial_path: "tiles/poll",
              object: self
            })
  end
end
