class CreateInitialReviews < ActiveRecord::Migration
  def change
    create_table :initial_reviews do |t|
      t.integer :progress_id, :limit => 26
      t.integer :person_id, :limut => 11
      t.string :body, :limit => 500
      t.string :target_grade, :limit => 50
      t.integer :checkbox, :limit => 1
      t.integer :checkbox2, :limit => 1
      t.integer :checkbox3, :limit => 1
      t.integer :checkbox4, :limit => 1
      t.integer :created_by_id, :limit => 11
      t.date :created_at

      t.timestamps
    end
  end
end
