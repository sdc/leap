class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.string :color
      t.boolean :deleted

      t.timestamps null: false
    end
  end
end
