class CreateAspirations < ActiveRecord::Migration
  def change
    create_table :aspirations do |t|
      t.integer :person_id, :limit => 11
      t.integer :created_by_id, :limit => 11
      t.string :aspiration, :limit => 255
      t.date :created_at

      t.timestamps
    end
  end
end
