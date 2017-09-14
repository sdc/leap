class AddCreatedDateToContinuingLearnings < ActiveRecord::Migration
  def change
    add_column :continuing_learnings, :created_date, :date
  end
end
