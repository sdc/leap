class CreateEngMathAttendance < ActiveRecord::Migration
  def up
   create_table     :eng_math_attendance do |t|
      t.integer     :person_code, :limit => 11
      t.integer     :person_id, :limit => 11
      t.string      :year, :limit => 10
      t.string      :course, :limit => 20
      t.string      :course_title, :limit => 255
      t.integer     :uio_id, :limit => 11
      t.string      :repmode, :limit => 20
      t.string      :course_status, :limit => 30
      t.string      :last_three_att, :limit => 3
      t.date        :last_date_att
    end

    add_index :eng_math_attendance, :person_id, :name => 'person_id'
    add_index :eng_math_attendance, :year, :name => 'year'
    add_index :eng_math_attendance, :course, :name => 'course'

    execute "ALTER TABLE eng_math_attendance AUTO_INCREMENT = 1"

  end

  def down
    drop_table :eng_math_attendance
  end
end

