class Intervention < ActiveRecord::Migration
  def change
    create_table :interventions do |t|
      t.integer :person_id
      t.text :referral_text
      t.text :disc_text
      t.integer :created_by_id
      t.string :pi_type
      t.string :referral_category
      t.date :incident_date
      t.boolean :referral
      t.integer :workshops
      t.timestamps
    end
  end
end
