class RenameWorkPackageColumns < ActiveRecord::Migration
  def up
  	rename_column :work_packages, :location, :description
  	rename_column :work_packages, :key_strengths, :learnt
  	rename_column :work_packages, :development, :next_steps
  end

  def down
  end
end
