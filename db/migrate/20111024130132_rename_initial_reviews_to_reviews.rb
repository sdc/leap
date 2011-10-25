class RenameInitialReviewsToReviews < ActiveRecord::Migration
  def up
    rename_table 'initial_reviews','reviews'
  end

  def down
    rename_table 'reviews', 'initial_reviews'
  end
end
