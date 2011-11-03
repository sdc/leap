class AddBodyToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :body, :text
    add_column :reviews, :published, :boolean
  end
end
