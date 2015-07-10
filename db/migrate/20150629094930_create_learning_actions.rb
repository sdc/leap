class CreateLearningActions < ActiveRecord::Migration
  def change
    create_table :learning_actions do |t|
      t.integer :person_id
      t.integer :created_by_id
      t.boolean :deleted
      t.text :unit
      t.string :target_outcome
      t.string :outcome
      t.text :body
      t.text :reflection
      t.timestamps null: false
    end
  end
end
