class CreateProgressReviews < ActiveRecord::Migration
  def change
    create_table :progress_reviews do |t|
      t.integer :person_id, :limit => 11
      t.integer :progress_id, :limit => 26
      t.integer :number, :limit => 1
      t.string :body, :limit => 500
      t.string :working_at, :limit => 100
      t.string :level, :limit => 10
      t.integer :attendance, :limit => 3
      t.integer :created_by_id, :limit => 11
      t.date :created_at

      t.timestamps
    end
  end
end
