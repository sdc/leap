class AddNoteToPeople < ActiveRecord::Migration
  def change
    add_column :people, :note, :text
  end
end
