class AddCourseTypeSubToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :course_type_sub, :string

	add_index :attendances, :course_type_sub, :name => "course_type_sub"
  end
end
