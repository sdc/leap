class CreateInductionQuestions < ActiveRecord::Migration
  def change
    create_table :induction_questions do |t|
      t.integer :person_id, :limit => 11
      t.integer :created_by_id, :limit => 11
      t.string :question, :limit => 255
      t.text :answer
      t.date :created_at

      t.timestamps
    end
  end
end
