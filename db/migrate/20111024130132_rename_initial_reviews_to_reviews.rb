class RenameInitialReviewsToReviews < ActiveRecord::Migration
  def up
    rename_table 'initial_reviews','review_lines'
    add_column :review_lines, :window, :string
    add_column :review_lines, :unit, :string
    add_column :review_lines, :review_id, :integer
    Event.where(:eventable_type => "InitialReview").each do |r|
      r.update_attribute("eventable_type","ReviewLine")
      r.eventable.update_attribute("window","Initial Review 11/12")
    end
    View.where(:name => "reviews").each do |v|
      v.events = (v.events - ["ReviewLine"] + ["Review","ReviewLine"]).uniq
      v.controls = "events/create/review_line"
      v.save
    end
    add_index :review_lines, :review_id
  end

  def down
    rename_table 'review_lines', 'initial_reviews'
  end
end
