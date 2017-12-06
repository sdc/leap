class AddParTypeToProgresses < ActiveRecord::Migration
  def up
    add_column :progresses, :par_type, :string, :limit => 10
    Progress.update_all({"par_type" => "FULLTIME"})
  end
  def down
  	remove_column :progresses, :par_type
  end
end
