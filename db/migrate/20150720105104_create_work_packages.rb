class CreateWorkPackages < ActiveRecord::Migration
  def up
   create_table :work_packages do |t|
      t.integer :person_id
      t.integer :created_by_id
      t.string  :wp_type
      t.string  :location
      t.text    :key_strengths
      t.text    :development
      t.integer :days
      t.timestamps
    end
  end

  def down
    drop_table :work_packages
  end
end
