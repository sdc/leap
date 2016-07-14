class AddEnrolCourseToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :enrol_course, :string, :limit => 50
  end
end
