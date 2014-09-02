class CreateMdlGradeTracks < ActiveRecord::Migration
  def change
    create_table :mdl_grade_tracks do |t|
      t.string :name
      t.string :course_type
      t.integer :mdl_id
      t.string :tag
      t.string :mag
      t.string :total
      t.integer :person_id
      t.timestamps
    end
  end
end
