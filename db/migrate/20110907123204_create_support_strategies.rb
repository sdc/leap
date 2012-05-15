class CreateSupportStrategies < ActiveRecord::Migration
  def self.up
    create_table :support_strategies do |t|
      t.integer :person_id
      t.integer :created_by_id
      t.integer :event_id
      t.text    :body
      t.datetime :agreed_date
      t.datetime :completed_date
      t.datetime :declined_date
      t.timestamps
    end
    add_index :support_strategies, :person_id
    add_index :support_strategies, :event_id
  end

  def self.down
    drop_table :support_strategies
  end
end
