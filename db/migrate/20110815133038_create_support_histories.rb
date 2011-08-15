class CreateSupportHistories < ActiveRecord::Migration
  def self.up
    create_table :support_histories do |t|
      t.integer :person_id
      t.integer :created_by_person_id
      t.string :body
      t.string :category
    end
  end

  def self.down
    drop_table :support_histories
  end
end
