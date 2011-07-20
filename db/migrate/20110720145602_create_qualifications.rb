class CreateQualifications < ActiveRecord::Migration
  def self.up
    create_table :qualifications do |t|
      t.integer :person_id
      t.string :title
      t.string :grade
      t.integer :mis_id

      t.timestamps
    end
  end

  def self.down
    drop_table :qualifications
  end
end
