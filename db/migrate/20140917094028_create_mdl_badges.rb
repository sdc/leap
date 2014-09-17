class CreateMdlBadges < ActiveRecord::Migration
  def change
    create_table :mdl_badges do |t|
      t.integer :person_id
      t.string :title
      t.string :image_url
      t.text :body
      t.integer :mdl_course_id
      t.string :link_url
      t.timestamps
    end
  end
end
