class CreateTtActivities < ActiveRecord::Migration
  def change
    create_table :tt_activities do |t|
      t.integer :person_id
      t.text :body
      t.string :category
      t.datetime :start_time
      t.integer :timetable_length
      t.string :repeat_type
      t.integer :repeat_number
      t.integer :created_by_id
      t.date :tmp_date
      t.datetime :tmp_time
      t.timestamps
    end
  end
end
