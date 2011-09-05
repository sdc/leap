class AddStartDateToPersonCourse < ActiveRecord::Migration
  def self.up
    add_column :person_courses, :start_date, :date
  end

  def self.down
    remove_column :person_courses, :start_date
  end
end
