module MisPerson

  def self.included receiver
    receiver.extend ClassMethods
    receiver.belongs_to :mis_person, :class_name => "Ebs::Person", :foreign_key => :mis_id
    receiver.belongs_to :mis,        :class_name => "Ebs::Person", :foreign_key => :mis_id
  end

  module ClassMethods

    def connector
      "EBS connector"
    end

    def import(mis_id, options = {})
      mis_id = mis_id.id if mis_id.kind_of? Ebs::Person
      options.reverse_merge! :save => true, :courses => true, :attendances => true, :quals => true
      logger.info "Importing user #{mis_id}"
      if (ep = (Ebs::Person.find_by_person_code(mis_id) or Ebs::Person.find_by_network_userid(mis_id)))
        @person = Person.find_or_create_by_mis_id(ep.id)
        @person.update_attributes(
          :forename      => ep.forename,
          :surname       => ep.surname,
          :middle_names  => ep.middle_names && ep.middle_names.split,
          :address       => [ep.address.address_line_1,ep.address.address_line_2,
                             ep.address.address_line_3,ep.address.address_line_4].reject{|a| a.blank?},
          :town          => ep.address.town,
          :postcode      => [ep.address.uk_post_code_pt1,ep.address.uk_post_code_pt2].join(" "),
          :mobile_number => ep.mobile_phone_number,
          :next_of_kin   => [ep.fes_next_of_kin, ep.fes_nok_contact_no].join(" "),
          :date_of_birth => ep.date_of_birth,
          :uln           => ep.unique_learn_no,
          :mis_id        => ep.person_code,
          :username      => (ep.network_userid or mis_id)
        )
        @person.save if options[:save] 
        @person.import_courses if options[:courses]
        @person.import_attendances if options[:attendances]
        @person.import_quals if options[:quals]
        return @person
      else
        return false
      end
    end

  def mis_search_for(query)
    Ebs::Person.search_for(query).limit(10).map{|p| import(p,:save => false, :courses => false)}
  end 
  end

  # Instance methods

  def timetable_events(options = {})
    reds = if options == :next
      Ebs::RegisterEventDetailsSlot.where(:object_id => mis_id, :object_type => ['L','T']).
        where("planned_start_date > ?", Time.now).
        order(:planned_start_date).limit(1)
    else
      from = options[:from] || Date.today.beginning_of_week
      to   = options[:to  ] || from.end_of_week
      Ebs::RegisterEventDetailsSlot.where(:object_id => mis_id, :object_type => ['L','T'], :planned_start_date => from..to)
    end
    reds.map do |s| 
      TimetableEvent.create(
        :mis_id       => s.register_event_id,
        :title        => s.description,
        :start        => s.actual_start_date || s.planned_start_date,
        :end          => s.actual_end_date   || s.planned_end_date,
        :mark         => s.usage_code,
        :generic_mark => s.generic_mark,
        :rooms        => s.rooms.map{|r| r.room_code},
        :teachers     => s.teachers.map{|t| Person.get(t)}
      )
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
    return self
  end

  def import_attendances
    last_date = unless attendances.empty?
      attendances.last.week_beginning
    else
      Date.civil(1900,1,1)
    end
    mis_person.attendances.
      where("start_week > ?",last_date).
      each do |att|
        attendances.create(
          :week_beginning => att.start_week,
          :att_year   => att.attendance,
          :att_3_week => att.attendance_last3wks,
          :att_week   => att.attendance_weekly
        )
      end
  end

  def import_quals
    mis_person.learner_aims.each do |la|
      next unless la.unit_instance_occurrence && la.grade
      next unless Qualification.where(:mis_id => la.id).empty?
      Qualification.create(
        :mis_id     => la.id,
        :title      => la.unit_instance_occurrence.long_description,
        :grade      => la.grade,
        :person_id  => id,
        :created_at => la.exp_end_date
      )
    end
  end
end

module MisCourse

  def self.included receiver
    receiver.extend ClassMethods
    receiver.belongs_to :mis, :class_name => "Ebs::UnitInstanceOccurrences", :foreign_key => :mis_id
    receiver.belongs_to :mis_course, :class_name => "Ebs::UnitInstanceOccurrence", :foreign_key => :mis_id
  end

  def import_people
    mis_course.people_units.each do |pu|
      person = Person.get(pu.person_code)
      pc= PersonCourse.find_or_create_by_person_id_and_course_id(person.id,id)
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

  module ClassMethods
    def import(mis_id, options = {})
      options.reverse_merge! :save => true, :people => false
      if (ec = Ebs::UnitInstanceOccurrence.find_by_uio_id(mis_id))
        @course = Course.find_or_create_by_mis_id(mis_id)
        @course.update_attributes(
          :title  => ec.long_description,
          :code   => ec.fes_uins_instance_code,
          :year   => ec.calocc_occurrence_code,
          :mis_id => ec.id
        )
        @course.save if options[:save]
        @course.import_people if options[:people]
        return @course
      else
        return false
      end
    end
  end
end

module MisQualification
  def self.included receiver
    receiver.belongs_to :mis, :class_name => "Ebs::LearnerAim", :foreign_key => :mis_id
  end
end
