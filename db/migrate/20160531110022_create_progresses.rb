class CreateProgresses < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.primary_key :id
      t.integer :person_id, :limit => 11
      t.string :course_title, :limit => 255
      t.string :course_code, :limit => 15
      t.string :course_year, :limit => 5
      t.string :course_type, :limit => 50
      t.string :course_status, :limit => 50
      t.integer :course_tutor_id, :limit => 11
      t.string :ir_body, :limit => 500, :null => true
      t.string :ir_aspiration, :limit => 100, :null => true
      t.string :ir_target_grade, :limit => 100, :null => true
      t.boolean :ir_checkbox, :null => true
      t.boolean :ir_checkbox2, :null => true
      t.boolean :ir_checkbox3, :null => true
      t.boolean :ir_checkbox4, :null => true
      t.date :ir_completed, :null => true

      t.timestamps
    end
  end
end
