class Ebs::Attendance < Ebs::Model

  set_table_name "sdc_ilp_lrn_attend_weekly"

  belongs_to :person,  :foreign_key => "per_person_code"

end
