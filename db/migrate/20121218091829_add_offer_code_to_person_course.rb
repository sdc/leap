class AddOfferCodeToPersonCourse < ActiveRecord::Migration
  def change
    add_column :person_courses, :offer_code, :string
  end
end
