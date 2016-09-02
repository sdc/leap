class CreateProgresses < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.integer :person_id, :limit => 11, :null => false
      t.string :uio_id, :limit => 11, :null => false
      t.string :course_title, :limit => 255, :null => false
      t.string :course_code, :limit => 15, :null => false
      t.string :course_year, :limit => 5
      t.string :course_type, :limit => 50
      t.string :course_status, :limit => 50
      t.integer :course_tutor_id, :limit => 11
      t.string :bksb_maths_ia, :limit => 100
      t.string :bksb_english_ia, :limit => 100
      t.string :bksb_maths_da, :limit => 100
      t.string :bksb_english_da, :limit => 100
      t.float :qca_score
      t.string :nat_target_grade, :limit => 50
      t.string :subject_grade, :limit => 100
      t.timestamps
    end
  end
end
