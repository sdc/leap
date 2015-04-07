class AddPageTypeToViews < ActiveRecord::Migration
  def change
    add_column :views, :page_type, :string
  end
end
