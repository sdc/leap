class AddTutorToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :tutor_id, :integer
  end

  def self.down
    remove_column :people, :tutor_id
  end
end
