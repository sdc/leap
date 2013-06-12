class CreateSimplePollAnswers < ActiveRecord::Migration
  def change
    create_table :simple_poll_answers do |t|
      t.integer :person_id
      t.integer :created_by_id
      t.integer :simple_poll_id
      t.string :answer
      t.timestamps
    end
  end
end
