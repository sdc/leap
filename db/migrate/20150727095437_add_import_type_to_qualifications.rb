class AddImportTypeToQualifications < ActiveRecord::Migration
  def change
    add_column :qualifications, :import_type, :string
  end
end
