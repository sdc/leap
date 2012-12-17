class CreateAcheivements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.integer :person_id
      t.integer :created_by_id
      t.date :year
      t.text :body
      t.timestamps
    end
  end
end
