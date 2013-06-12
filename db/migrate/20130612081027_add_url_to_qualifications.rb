class AddUrlToQualifications < ActiveRecord::Migration
  def change
    add_column :qualifications, :url, :string
  end
end
