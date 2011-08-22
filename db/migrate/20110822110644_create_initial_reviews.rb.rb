class CreateInitialReviews < ActiveRecord::Migration
  def self.up
    create_table :initial_reviews do |t|
      t.integer  :person_id
      t.text     :body
      t.integer  :created_by_id
      t.integer :quality
      t.integer :attitude
      t.integer :punctuality
      t.integer :completion
      t.timestamps
    end
  end

  def self.down
    drop_table :initial_reviews
  end
end
