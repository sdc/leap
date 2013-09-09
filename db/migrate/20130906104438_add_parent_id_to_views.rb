class AddParentIdToViews < ActiveRecord::Migration
  def change
    add_column :views, :parent_id, :integer
  end
end
