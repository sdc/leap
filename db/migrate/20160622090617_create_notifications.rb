class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :person_id, :limit => 11
      t.integer :event_id, :limit => 11
      t.integer :notified, :limit => 1, :default => 0

      t.timestamps
    end
  end
end
