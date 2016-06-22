class AddReadToEvents < ActiveRecord::Migration
  def change
    add_column :events, :read, :integer, :limit => 1
    add_column :events, :, :default
    add_column :events, :=, :string
  end
end
