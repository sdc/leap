class AddWorkshopToSupportRequests < ActiveRecord::Migration
  def self.up
    add_column :support_requests, :workshop, :boolean
  end

  def self.down
    remove_column :support_requests, :workshop
  end
end
