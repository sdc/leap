class CreateProfileQuestions < ActiveRecord::Migration
  def change
    create_table :profile_questions do |t|
      t.integer :person_id 
      t.integer :created_by_id 
      t.string :question
      t.string :answer
      t.timestamps
    end
  end
end
