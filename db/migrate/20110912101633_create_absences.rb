class CreateAbsences < ActiveRecord::Migration
  def self.up
    create_table :absences do |t|
      t.integer :person_id
      t.integer :created_by_id
      t.integer :lessons_missed
      t.string  :category
      t.text    :body
      t.string  :usage_code
      t.string  :contact_category
      t.timestamps
    end
    add_index :absences, :person_id
  end

  def self.down
    drop_table :absences
  end
end
