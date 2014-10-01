class CreateGlobalNews < ActiveRecord::Migration
  def change
    create_table :global_news do |t|
      t.string :title
      t.string :subtitle
      t.text :body
      t.timestamps
    end
  end
end
