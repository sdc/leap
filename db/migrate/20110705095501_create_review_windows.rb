class CreateReviewWindows < ActiveRecord::Migration
  def self.up
    create_table :review_windows do |t|
      t.date :start_date
      t.date :end_date
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :review_windows
  end
end
