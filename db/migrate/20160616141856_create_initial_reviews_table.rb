class CreateInitialReviewsTable < ActiveRecord::Migration
  def change
    create_table :initial_reviews do |t|
      t.integer :progress_id, :limit => 11, :null => false
      t.integer :person_id, :limit => 11, :null => false
      t.string :body, :limit => 500
      t.string :target_grade, :limit => 50
      t.integer :created_by_id, :limit => 11, :null => false
      t.date :created_at, :null => false

      t.timestamps
    end
  end
end
