class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer  :person_id
      t.string   :eventable_type, :null => false
      t.integer  :eventable_id,   :null => false
      t.datetime :event_date,     :null => false
      t.integer  :about_person_id
      t.integer  :parent_id
      t.string   :transition
      t.integer  :created_by_id
      t.timestamps
    end
    add_index :events, :person_id
    add_index :events, :eventable_type
    add_index :events, :eventable_id
    add_index :events, :event_date
    add_index :events, :parent_id
    add_index :events, :transition
  end

  def self.down
    drop_table :events
  end
end
