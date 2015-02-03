class AddDeletedToAbsences < ActiveRecord::Migration
  def change
    add_column :absences, :deleted, :boolean
  end
end
