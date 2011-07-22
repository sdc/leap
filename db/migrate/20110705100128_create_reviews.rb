class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :review_window_id
      t.integer :person_id
      t.string :status
      t.text :body
      t.integer :created_by_id
      t.timestamps
    end
  end

  def self.down
    drop_table :reviews
  end
end
