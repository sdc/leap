class ReviewWindow < ActiveRecord::Base

  has_many :review

  named_scope :live, where("start_date < ? and end_date > ?", Date.today,Date.today)

end
