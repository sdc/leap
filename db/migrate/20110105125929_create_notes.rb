class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :person_id
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
