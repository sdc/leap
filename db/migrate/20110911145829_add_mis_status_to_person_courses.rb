class AddMisStatusToPersonCourses < ActiveRecord::Migration
  def self.up
    add_column :person_courses, :mis_status, :string
  end

  def self.down
    remove_column :person_courses, :mis_status
  end
end
