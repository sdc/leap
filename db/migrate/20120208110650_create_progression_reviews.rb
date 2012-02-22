class CreateProgressionReviews < ActiveRecord::Migration
  def up
    create_table :progression_reviews do |t|
      t.integer :person_id
      t.integer :created_by_id
      t.boolean :approved
      t.string  :reason
      t.timestamps
    end
    add_index :progression_reviews, :person_id
  end

  def down
    drop_table :progression_reviews
  end
end
