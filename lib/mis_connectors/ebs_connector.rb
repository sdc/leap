class MisConnector

  def self.get_person(uln)
    puts "Importing ebs person"
    if (ep = Ebs::Person.find_by_unique_learn_no(uln))
      @person = Person.find_or_create_by_uln(uln)
      @person.update_attributes(
        :forename      => ep.forename,
        :surname       => ep.surname,
        :middle_names  => ep.middle_names && ep.middle_names.split,
	      :address       => [ep.address.address_line_1,ep.address.address_line_2,
		                       ep.address.address_line_3,ep.address.address_line_4].reject{|a| a.blank?},
	      :town          => ep.address.town,
	      :postcode      => [ep.address.uk_post_code_pt1,ep.address.uk_post_code_pt2].join(" "),
	      :mobile_number => ep.mobile_phone_number,
	      :next_of_kin   => ep.fes_nok_contact_no,
	      :date_of_birth => ep.date_of_birth,
        :uln           => uln
      )
      @person.save
      return @person
    else
      return false
    end
  end

end
