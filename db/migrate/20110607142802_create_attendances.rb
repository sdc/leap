class CreateAttendances < ActiveRecord::Migration
  def self.up
    create_table :attendances do |t|
      t.date :week_beginning
      t.integer :person_id
      t.integer :att_year
      t.integer :att_3_week
      t.integer :att_week
      t.integer :created_by_id
      t.timestamps
    end
    add_index :attendances, :person_id
    add_index :attendances, :week_beginning
  end

  def self.down
    drop_table :attendances
  end
end
