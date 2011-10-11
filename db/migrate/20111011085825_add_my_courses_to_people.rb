class AddMyCoursesToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :my_courses, :string
  end

  def self.down
    remove_column :people, :my_courses
  end
end
