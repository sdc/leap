class Ebs::Target < Ebs::Model

  set_table_name "sdc_ilp_targets"

  belongs_to :person

end
