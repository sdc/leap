class AddTutorgroupToPersonCourses < ActiveRecord::Migration
  def change
    add_column :person_courses, :tutorgroup, :string
  end
end
