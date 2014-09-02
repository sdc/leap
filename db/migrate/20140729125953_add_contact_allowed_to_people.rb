class AddContactAllowedToPeople < ActiveRecord::Migration
  def change
    add_column :people, :contact_allowed, :boolean
  end
end
