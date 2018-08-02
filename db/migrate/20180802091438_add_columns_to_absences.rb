class AddColumnsToAbsences < ActiveRecord::Migration
  def change
    add_column :absences, :notified_at, :datetime
    add_column :absences, :hours, :string
    add_column :absences, :mins, :string
    add_column :absences, :start_date, :datetime
    add_column :absences, :end_date, :datetime
  end
end
