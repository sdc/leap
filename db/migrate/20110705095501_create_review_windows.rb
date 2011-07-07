class CreateReviewWindows < ActiveRecord::Migration
  def self.up
    create_table :review_windows do |t|
      t.date :start_date
      t.date :end_date
      t.string :name
      t.timestamps
    end
    ReviewWindow.create(
      :name => "Last two months testing Review",
      :start_date => Date.today - 1.months,
      :end_date => Date.today
    )
  end

  def self.down
    drop_table :review_windows
  end
end
