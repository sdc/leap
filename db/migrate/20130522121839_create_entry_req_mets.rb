class CreateEntryReqMets < ActiveRecord::Migration
  def change
    create_table :entry_req_mets do |t|
      t.integer :entry_req_id
      t.integer :person_id
      t.string :no_but
      t.integer :created_by_id
      t.boolean :met
      t.timestamps
    end
    add_index :entry_req_mets, :entry_req_id
    add_index :entry_req_mets, :person_id
    add_index :entry_req_mets, :created_by_id
  end
end
