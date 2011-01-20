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
      t.timestamps
    end
  end

  def self.down
    drop_table :targets
  end
end
