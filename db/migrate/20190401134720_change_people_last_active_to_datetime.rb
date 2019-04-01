class ChangePeopleLastActiveToDatetime < ActiveRecord::Migration
  def up
    change_column :people, :last_active, :datetime
  end

  def down
    change_column :people, :last_active, :date
  end
end
