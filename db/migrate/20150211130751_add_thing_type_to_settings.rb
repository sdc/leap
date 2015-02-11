class AddThingTypeToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :thing_type, :string
    add_column :settings, :thing_id, :integer
  end
end
