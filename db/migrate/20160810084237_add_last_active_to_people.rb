class AddLastActiveToPeople < ActiveRecord::Migration
  def change
    add_column :people, :last_active, :date
  end
end
