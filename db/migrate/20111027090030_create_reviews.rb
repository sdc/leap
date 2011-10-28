class CreateReviews < ActiveRecord::Migration
  def up
    create_table :reviews do |t|
      t.integer :person_id
      t.integer :created_by_id
      t.string  :window
      t.integer :attendance
      t.integer :score
      t.timestamps
    end
  end

  def down
  end
end
