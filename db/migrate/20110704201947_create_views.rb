class CreateViews < ActiveRecord::Migration
  def self.up
    create_table :views do |t|
      t.string :transitions
      t.string :events
      t.string :icon_url
      t.string :affiliations
      t.string :name
      t.string :label
      t.string :controls
      t.integer :position
      t.boolean :in_list
      t.timestamps
    end
  end

  def self.down
    drop_table :views
  end
end
