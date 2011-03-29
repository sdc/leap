class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer  :person_id
      t.string   :eventable_type, :null => false
      t.integer  :eventable_id,   :null => false
      t.datetime :event_date,     :null => false
      t.integer  :parent_id
      t.string   :transition
      t.timestamps
    end
    add_index(:events, :person_id,:eventable_type,:eventable_id,:event_date,:parent_id,:transition)
  end

  def self.down
    drop_table :events
  end
end
