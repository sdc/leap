class Ebs::Address < Ebs::Model

  set_primary_key "per_person_code"  
  set_table_name "student_addresses"

  belongs_to :person,  :foreign_key => "per_person_code"

  def postcode
    (uk_post_code_pt1 || "") + " " + (uk_post_code_pt2 || "")
  end

end
