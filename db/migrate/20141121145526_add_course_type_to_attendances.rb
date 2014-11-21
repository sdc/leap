class AddCourseTypeToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :course_type, :string
    Attendance.update_all({"course_type" => "overall"})
  end
end
