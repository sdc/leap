class CreateEventNotes < ActiveRecord::Migration
  def change
    create_table :event_notes do |t|
      t.integer :person_id
      t.integer :created_by_id
      t.text :body
      t.integer :parent_event_id

      t.timestamps
    end
  end
end
