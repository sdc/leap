class CreateLsfBursaryFunds < ActiveRecord::Migration
  def up
   create_table     :lsf_bursary_funds do |t|
      t.integer     :mis_id, :limit => 11
      t.integer     :person_id, :limit => 11
      t.string      :fund, :limit => 255
      t.string      :support_category, :limit => 255
      t.string      :support_type, :limit => 255
      t.string      :year, :limit => 20
    end

    add_index :lsf_bursary_funds, :mis_id, :name => 'mis_id'
    add_index :lsf_bursary_funds, :person_id, :name => 'person_id'
    add_index :lsf_bursary_funds, :year, :name => 'year'

    execute "ALTER TABLE lsf_bursary_funds AUTO_INCREMENT = 1"

  end

  def down
    drop_table :lsf_bursary_funds
  end
end

