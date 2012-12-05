class ViewControlsForAll < ActiveRecord::Migration
  def up
    View.all.select{|v| v.affiliations.size > 1 and v.affiliations.detect{|a| a == "staff"} and v.controls}.each do |v|
      new_view = v.dup
      new_view.affiliations.delete("staff")
      new_view.controls = nil
      new_view.save
      v.affiliations = ["staff"]
      v.save
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
