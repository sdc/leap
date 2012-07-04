class AddStaffToPeople < ActiveRecord::Migration
  def change
    add_column :people, :staff, :boolean
  end
end
