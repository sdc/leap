class AddIconClassToViews < ActiveRecord::Migration
  def change
    add_column :views, :icon_class, :string, :limit => 50
  end
end
