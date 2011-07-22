class ContactLogs < ActiveRecord::Migration
  def self.up
    create_table :contact_logs do |t|
      t.integer :person_id
      t.text :body
      t.integer :created_by_id
      t.timestamps
    end
    add_index :contact_logs, :person_id
    add_index :contact_logs, :created_by_id
  end

  def self.down
    drop_table :contact_logs  
  end
end
