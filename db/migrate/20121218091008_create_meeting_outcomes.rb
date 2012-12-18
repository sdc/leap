class CreateMeetingOutcomes < ActiveRecord::Migration
  def change
    create_table :meeting_outcomes do |t|
      t.string :title
      t.text :body
      t.integer :person_id
      t.integer :created_by_id
      t.timestamps
    end
  end
end
