module MisPerson

  def self.included receiver
    receiver.extend ClassMethods
    receiver.belongs_to :mis_person, :class_name => "Ebs::Person", :foreign_key => :mis_id
  end

  module ClassMethods

    def connector
      "EBS connector"
    end

    def import(uln, options = {})
      uln = uln.unique_learn_no if uln.kind_of? Ebs::Person
      options.reverse_merge! :save => true, :courses => true
      logger.info "Importing user #{uln}"
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
        @person.save if options[:save] 
        @person.import_courses if options[:courses]
        return @person
      else
        return false
      end
    end
 
    def mis_search_for(query)
      Ebs::Person.search_for(query).limit(10).map{|p| import(p,:save => false, :courses => false)}
    end

  end

  def photo_path
    return Ilp2::Application.config.mis_photo_path + "/" + mis_id.to_s + ".jpg"
  end

  def import_courses
    mis_person.people_units.each do |pu|
      course = Course.get(pu.uio_id)
      pc= PersonCourse.find_or_create_by_person_id_and_course_id(id,course.id)
      if pu.unit_type == "A" 
        pc.update_attributes(:status => :not_started,
                             :application_date => pu.created_date
                            )
      elsif pu.unit_type == "R"
        pc.update_attributes(:enrolment_date => pu.created_date,
                             :status => Ilp2::Application.config.mis_progress_codes[pu.progress_code],
                             :end_date => pu.progress_date) unless pc.status == :not_started
      end
    end
  end

end

module MisCourse

  def self.included receiver
    receiver.extend ClassMethods
  end

  module ClassMethods
    def import(mis_id)
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
  end

end
