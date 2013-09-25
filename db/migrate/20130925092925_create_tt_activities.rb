class CreateTtActivities < ActiveRecord::Migration
  def change
    create_table :tt_activities do |t|
      t.integer :person_id
      t.text :body
      t.time :timetable_start
      t.time :timetable_end
      t.string :category
      t.date :start_date
      t.string :repeat_type
      t.integer :repeat_number

      t.timestamps
    end
  end
end
