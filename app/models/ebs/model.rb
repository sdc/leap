class Ebs::Model < ActiveRecord::Base

  self.abstract_class = true
  establish_connection :ebs

end
