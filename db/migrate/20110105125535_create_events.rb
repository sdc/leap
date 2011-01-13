class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :person_id
      t.string :eventable_type
      t.integer :eventable_id
      t.datetime :event_date
      t.integer :parent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
