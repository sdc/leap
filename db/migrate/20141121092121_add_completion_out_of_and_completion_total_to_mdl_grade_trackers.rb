class AddCompletionOutOfAndCompletionTotalToMdlGradeTrackers < ActiveRecord::Migration
  def change
    add_column :mdl_grade_tracks, :completion_out_of, :integer
    add_column :mdl_grade_tracks, :completion_total, :integer
  end
end
