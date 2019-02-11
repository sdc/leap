# Leap - Electronic Individual Learning Plan Software
# Copyright (C) 2011 South Devon College

# Leap is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Leap is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with Leap.  If not, see <http://www.gnu.org/licenses/>.

class Ebs::Model < ActiveRecord::Base

  ActiveRecord::Base.default_timezone = :local
  self.abstract_class = true
  establish_connection :ebs

  # for MS SQL Server that uses auto incrementing IDENTITY(1,1) primary key ID to stop
  # TinyTds::Error: Cannot insert the value NULL into column 'ID'
  def create_or_update(*args, &block)
    if Ebs::Model.using_sqlserver? && self.respond_to?(:id) && [nil,0].include?(self.id)
      if self.class.columns_hash['id'].is_identity?
        self.id = self.class.maximum(:id).to_i + 1
      elsif self.class.find_by_sql "select top 1 'x' from sys.sequences where name = '#{self.class.table_name.downcase+'_SEQ'}'"
        self.id = self.class.find_by_sql "select NEXT VALUE FOR [dbo].[#{self.class.table_name.downcase+'_SEQ'}] AS id"
      end
    end
    super
  rescue ActiveRecord::RecordNotUnique
    if Ebs::Model.using_sqlserver? && self.respond_to?(:id)
      self.id = nil
      retry
    else
      raise
    end
  end

  def self.using_sqlserver?
    (( Rails.configuration.database_configuration['ebs']['adapter'] || "none" ) == 'sqlserver')
  end

end
