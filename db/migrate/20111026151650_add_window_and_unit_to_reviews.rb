class AddWindowAndUnitToReviews < ActiveRecord::Migration
  def change
    add_column :review_lines, :window, :string
    add_column :review_lines, :unit, :string
    add_column :review_lines, :review_id, :integer
  end
end
