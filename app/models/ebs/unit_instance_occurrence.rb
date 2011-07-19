class Ebs::UnitInstanceOccurrence < Ebs::Model

  set_primary_key :uio_id
  
  has_many :people_units, :foreign_key => "uio_id"

end
