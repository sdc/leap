class AddPredictedToQualifications < ActiveRecord::Migration
  def up
    add_column :qualifications, "predicted", :boolean 
    add_column :qualifications, "qual_type", :string
    add_column :qualifications, "awarding_body", :string
    Event.where(:eventable_type => "Qualification").update_all(:transition => "complete")
  end

  def down
    Qualification.where(:predicted => true).destroy_all
    remove_column :qualifications, "predicted", "qual_type", "awarding_body"
    Event.where(:eventable_type => "Qualification").update_all(:transition => "create")
  end


end
