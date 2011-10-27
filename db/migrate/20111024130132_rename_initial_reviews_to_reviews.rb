class RenameInitialReviewsToReviews < ActiveRecord::Migration
  def up
    rename_table 'initial_reviews','review_lines'
  end

  def down
    rename_table 'review_lines', 'initial_reviews'
  end
end
