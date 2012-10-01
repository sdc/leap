class ChangeSupportHistoryBodyToText < ActiveRecord::Migration
  def up
    change_column :support_histories, :body, :text
  end

  def down
  end
end
