class AddMoreDetailsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :home_phone, :string
    add_column :people, :personal_email, :string
  end
end
