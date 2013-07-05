class CreatePathways < ActiveRecord::Migration
  def change
    create_table :pathways do |t|
      t.integer :person_id
      t.string :pathway
      t.string :subject
      t.integer :created_by_id

      t.timestamps
    end
  end
end
