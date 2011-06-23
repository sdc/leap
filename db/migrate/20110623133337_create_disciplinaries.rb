class CreateDisciplinaries < ActiveRecord::Migration
  def self.up
    create_table :disciplinaries do |t|
      t.integer :person_id
      t.text :body
      t.integer :level

      t.timestamps
    end
  end

  def self.down
    drop_table :disciplinaries
  end
end
