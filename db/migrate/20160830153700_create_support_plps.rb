class CreateSupportPlps < ActiveRecord::Migration
  def up
   create_table     :support_plps do |t|
      t.integer     :person_id, :limit => 11
      t.string      :name, :limit => 255
      t.string      :value, :limit => 255
      t.string      :description, :limit => 255
      t.string      :short_description, :limit => 255
      t.datetime    :start_date
      t.datetime    :end_date
      t.integer     :active, :limit => 1
      t.string      :domain, :limit => 255
      t.string      :source, :limit => 255
      t.integer     :created_by_id, :limit => 11
      t.timestamps
    end

    add_index :support_plps, :person_id, :name => 'person_id'
    add_index :support_plps, :active, :name => 'active'
    add_index :support_plps, :domain, :name => 'domain'

    execute "ALTER TABLE support_plps AUTO_INCREMENT = 1"

  end

  def down
    drop_table :support_plps
  end
end

