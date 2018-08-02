class ChangeAbsenceColumnNames < ActiveRecord::Migration
  def change
  	change_table :absences do |t|
  		t.rename :created_by_id, :created_by
  		t.rename :category, :reason
  		t.rename :body, :reason_extra
  		t.rename :contact_category, :contact
  	end	
  end
end
