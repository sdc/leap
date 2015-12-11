class AddActiveToGlobalNews < ActiveRecord::Migration
  def up
  	add_column :global_news, :active, :boolean
  	add_column :global_news, :from_time, :datetime
  	add_column :global_news, :to_time, :datetime
  	GlobalNews.update_all({"active" => false})
  	GlobalNews.order('id desc').limit(1).update_all({"active" => true})
  end
  def down
  	remove_column :global_news, :to_time
  	remove_column :global_news, :from_time
  	remove_column :global_news, :active
  end
end
