class NewSettings < ActiveRecord::Migration
  def up
    Settings.admin_users = Settings.admin_users.split(",")
  end

  def down
    Settings.admin_users = Settings.admin_users.join(",")
  end
end
