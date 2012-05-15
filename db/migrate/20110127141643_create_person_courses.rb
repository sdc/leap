class CreatePersonCourses < ActiveRecord::Migration
  def self.up
    create_table :person_courses do |t|
      t.integer :person_id
      t.integer :course_id
      t.datetime :application_date
      t.datetime :enrolment_date
      t.datetime :end_date
      t.datetime :start_date
      t.string   :status
      t.integer :created_by_id
      t.timestamps
    end
    add_index :person_courses, :person_id
    add_index :person_courses, :course_id
  end

  def self.down
    drop_table :person_courses
  end
end
