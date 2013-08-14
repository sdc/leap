class AddSeenToQualification < ActiveRecord::Migration
  def change
    add_column :qualifications, :seen, :boolean
  end
end
