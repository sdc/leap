class CreateDisciplinaries < ActiveRecord::Migration
  def self.up
    create_table :disciplinaries do |t|
      t.integer :person_id
      t.text :body
      t.integer :level
      t.integer :created_by_id
      t.timestamps
    end
    add_index :disciplinaries, :person_id
  end

  def self.down
    drop_table :disciplinaries
  end
end
