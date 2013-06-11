class CreateEntryReqs < ActiveRecord::Migration
  def change
    create_table :entry_reqs do |t|
      t.string :category 
      t.string :body
      t.integer :course_id
      t.boolean :live
      t.timestamps
    end
  end
end
