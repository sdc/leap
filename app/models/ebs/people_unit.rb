class Ebs::PeopleUnit < Ebs::Model

  belongs_to :person, :foreign_key => "person_code"
  belongs_to :unit_instance_occurrence , :foreign_key => "uio_id"
  #has_one :enrolment_special, :foreign_key => "people_units_id"

end
