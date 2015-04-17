class NewSettings < ActiveRecord::Migration
  def up
    begin
      if Settings.admin_users.kind_of? String
        Settings.admin_users = Settings.admin_users.split(",").map{|x| Person.find_by_username(x).id}
      end
    rescue
      # Yeah. But this only runs on new installs now and it always breaks because the setting API has changed
    end
  end

  def down
    Settings.admin_users = Settings.admin_users.map{|x| Person.find(x).username}.join(",")
  end
end
