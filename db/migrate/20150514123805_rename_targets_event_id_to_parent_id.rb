class RenameTargetsEventIdToParentId < ActiveRecord::Migration
  def change
    change_table :targets do |t|
      t.rename :event_id, :parent_id
    end
  end
end
