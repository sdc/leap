class CreateWorkPackages < ActiveRecord::Migration
  def up
   create_table :support_plps do |t|
      t.integer :person_id
      t.string  :name
      t.string  :value
      t.string  :description
      t.string  :short_description
      t.date    :start_date
      t.date    :end_date
      t.integer :active, :limit => 1
      t.string  :domain
      t.string  :source
      t.integer :created_by_id
      t.timestamps
    end

    add index :support_plps, :person_id
    add index :support_plps, :active
    add index :support_plps, :domain
  end

  def down
    drop_table :support_plps
  end
end
