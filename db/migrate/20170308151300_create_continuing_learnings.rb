class CreateContinuingLearnings < ActiveRecord::Migration
  def up
    create_table :continuing_learnings do |t|
      t.integer :person_code,    :limit => 11, :null => false
      t.integer :leap_person_id, :limit => 11, :null => false
      t.string  :dept,           :limit => 20
      t.string  :section,        :limit => 20
      t.string  :course_code,    :limit => 20
      t.integer :uio_id,         :limit => 11
      t.string  :course_desc,    :limit => 255
      t.string  :group1,         :limit => 50
      t.string  :answer_desc,    :limit => 255
      t.string  :answer_colour,  :limit => 50
      t.string  :answer_cat,     :limit => 255
    end

    add_index :continuing_learnings, :person_code, :name => "person_code"
    add_index :continuing_learnings, :leap_person_id, :name => "leap_person_id"

    execute "ALTER TABLE continuing_learnings AUTO_INCREMENT = 1"

  end

  def down
    drop_table :continuing_learnings
  end
end

