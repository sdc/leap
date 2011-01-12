class Ebs::Person < Ebs::Model

  set_primary_key :person_code

  has_many :targets
  has_one  :address, :class_name  => "Address",
                     :foreign_key => "per_person_code",
                     :conditions  => ["end_date IS NULL"]
end
