class CreateProgresses < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.primary_key :id
      t.integer :person_id, :limit => 11
      t.integer :uio_id, :limit => 20
      t.string :course_title, :limit => 255
      t.string :course_code, :limit => 15
      t.string :course_year, :limit => 5
      t.string :course_type, :limit => 50
      t.string :course_status, :limit => 50
      t.integer :course_tutor_id, :limit => 11

      t.timestamps
    end
  end
end
