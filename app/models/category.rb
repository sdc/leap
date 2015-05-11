class Category < ActiveRecord::Base

  default_scope { where(deleted: false) }

end
