class CreatePiReferrals < ActiveRecord::Migration
  def change
    create_table :pi_referrals do |t|
      t.integer :person_id
      t.text :body
      t.integer :created_by_id
      t.string :pi_type
      t.string :referral_category
      t.date :incident_date

      t.timestamps
    end
  end
end
