class CreateGoals < ActiveRecord::Migration
  def self.up
    create_table :goals do |t|
      t.integer :person_id
      t.text :body
      t.string :status
      t.timestamps
    end
    add_index :goals, :person_id
  end

  def self.down
    drop_table :goals
  end
end
