class RevertAbsenceColumnNames < ActiveRecord::Migration
  def change
  	change_table :absences do |t|
  		t.rename :created_by, :created_by_id
  		t.rename :reason, :category
  		t.rename :reason_extra, :body
  		t.rename :contact, :contact_category  
  	end	
  end
end
