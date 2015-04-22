class CreateTimelineViews < ActiveRecord::Migration
  def change
    create_table :timeline_views do |t|
      t.integer :parent_id
      t.string  :icon
      t.string  :title
      t.boolean :topic_person
      t.boolean :topic_course
      t.text    :events
      t.string  :controls
      t.string  :view_type
      t.string  :url
      t.boolean :aff_affiliate
      t.boolean :aff_staff
      t.boolean :aff_student
      t.boolean :aff_applicant
      t.boolean :admin_only
      t.timestamps null: false
    end
  end
end
