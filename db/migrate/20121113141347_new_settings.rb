class NewSettings < ActiveRecord::Migration
  def up
    Settings.admin_users = Settings.admin_users.split(",").map{|x| Person.find_by_username(x).id}
  end

  def down
    Settings.admin_users = Settings.admin_users.map{|x| Person.find(x).username}.join(",")
  end
end
