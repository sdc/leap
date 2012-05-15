class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :title
      t.string :code
      t.string :year
      t.string :mis_id
      t.timestamps
    end
    add_index :courses, :title
    add_index :courses, :code
  end

  def self.down
    drop_table :courses
  end
end
