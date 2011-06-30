class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :person_id
      t.text :body
      t.timestamps
    end
    add_index :notes, :person_id
  end

  def self.down
    drop_table :notes
  end
end
