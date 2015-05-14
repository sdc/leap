class CreateTimetableEvents < ActiveRecord::Migration
  def change
    create_table :timetable_events do |t|
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.string :room
      t.string :staff
      t.string :mark

      t.timestamps null: false
    end
  end
end
