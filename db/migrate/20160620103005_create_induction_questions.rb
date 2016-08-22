class CreateInductionQuestions < ActiveRecord::Migration
  def change
    create_table :induction_questions do |t|
      t.integer :person_id, :limit => 11, :null => false
      t.integer :created_by_id, :limit => 11, :null => false
      t.string :question, :limit => 255, :null => false
      t.text :answer
      t.date :created_at

      t.timestamps
    end
  end
end
