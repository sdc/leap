class AddVagueTitleToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :vague_title, :string
  end
end
