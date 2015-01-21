class AddAppTitleToEntryReqs < ActiveRecord::Migration
  def change
    add_column :entry_reqs, :app_title, :string
  end
end
