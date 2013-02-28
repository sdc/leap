class AddPhotoToPeople < ActiveRecord::Migration
  def change
    add_column :people, :photo, :binary
  end
end
