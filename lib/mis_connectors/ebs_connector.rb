class MisConnector

  def self.get_person(uln)
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
        :uln           => uln,
        :mis_id        => ep.id
      )
      @person.save
      update_courses_for(@person)
      return @person
    else
      return false
    end
  end

  def self.person_photo(person)
    return Ilp2::Application.config.mis_photo_path + "/" + person.mis_id.to_s + ".jpg"
  end

  def self.get_course(mis_id)
    if (ec = Ebs::UnitInstanceOccurrence.find_by_uio_id(mis_id))
      @course = Course.find_or_create_by_mis_id(mis_id)
      @course.update_attributes(
        :title  => ec.long_description,
        :code   => ec.fes_uins_instance_code,
        :year   => ec.calocc_occurrence_code,
        :mis_id => ec.id
      )
      @course.save
      return @course
    else
      return false
    end
  end

  def self.update_courses_for(person_or_course)
    # I'm assuming person (ebs or ilp) for now
    uln = person_or_course.uln
    @iperson = Person.find_by_uln(uln)
    @eperson = Ebs::Person.where(:unique_learn_no => uln).first#.include(:people_units)
    @eperson.people_units.each do |pu|
      puts pu.id
      course = get_course(pu.uio_id)
      pc= PersonCourse.find_or_create_by_person_id_and_course_id(@iperson.id,course.id)
      if pu.unit_type == "A" 
        pc.update_attribute("application_date",pu.created_date)
      elsif pu.unit_type == "R"
        pc.update_attribute("enrolment_date",pu.created_date)
      end
    end
  end




end
