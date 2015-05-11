class AddCategoryToEvents < ActiveRecord::Migration
  def change
    add_column :events, :category_id, :integer
  end
end
