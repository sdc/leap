class CreateProfileQuestions < ActiveRecord::Migration
  def change
    create_table :profile_questions do |t|
      t.integer :person_id 
      t.integer :created_by_id 
      t.string :question
      t.text :answer
      t.timestamps
    end
  end
end
