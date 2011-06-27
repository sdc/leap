class ContactLogs < ActiveRecord::Migration
  def self.up
    create_table :contact_logs do |t|
      t.integer :person_id
      t.integer :contact_person_id
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :contact_logs  
  end
end
