class CreateTargets < ActiveRecord::Migration
  def self.up
    create_table :targets do |t|
      t.integer :person_id
      t.integer :event_id
      t.text :body
      t.text :actions
      t.text :reflection
      t.datetime :target_date
      t.datetime :complete_date
      t.datetime :drop_date
      t.integer :created_by_id
      t.timestamps
    end
    add_index :targets, :person_id
    add_index :targets, :event_id
  end

  def self.down
    drop_table :targets
  end
end
