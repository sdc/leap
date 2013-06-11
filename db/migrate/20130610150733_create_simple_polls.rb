class CreateSimplePolls < ActiveRecord::Migration
  def change
    create_table :simple_polls do |t|
      t.string :question
      t.text :answers
      t.integer :created_by_id
      t.timestamps
    end
  end
end
