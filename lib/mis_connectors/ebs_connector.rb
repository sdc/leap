# Leap - Electronic Individual Learning Plan Software
# Copyright (C) 2011 South Devon College

# Leap is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Leap is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with Leap.  If not, see <http://www.gnu.org/licenses/>.

require 'csv'

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

    def resync(yr=nil, starting_mis_id=0, do_count=-1)
      yr = yr || Ebs::CalendarOccurrences.acyr
      starting_mis_id = starting_mis_id || 0
      do_count = do_count || -1
      puts Time.zone.now.strftime("%Y-%m-%d %T") + " Started for #{yr}"
      count = skipcount = 0
      # Ebs::Person.find_each(:include => :people_units) do |ep|
      # Ebs::Person.where(:person_code => [30145214,30146401,30148855,30161804,30136805]).find_each(:include => :people_units) do |ep|
      # Ebs::Person.where(:person_code => [30145214,30146401,30148855,30161804,30136805]).includes(:people_units).find_each(:conditions => "people_units.calocc_code = '#{yr}'") do |ep|
      # Ebs::Person.includes(:people_units).find_each(:conditions => "people_units.calocc_code = '#{yr}' and people.person_code >= '30135368' ") do |ep|
      Ebs::Person.includes(:people_units).find_each(:conditions => "people_units.calocc_code = '#{yr}' and people.person_code >= #{starting_mis_id}") do |ep|
        begin
        break if do_count >= 0 && count >= do_count   # for testing 
	  skipcount +=1
          next unless ep.people_units.detect{|pc| pc.calocc_code == yr} if yr
          count += 1
          imported_ep = import(ep)
          puts Time.zone.now.strftime("%Y-%m-%d %T") + " #{count}:\tskip #{skipcount-1}\timport [#{imported_ep.mis_id}] #{imported_ep.name}"
          # MdlGradeTrack.import_for ep
	  skipcount = 0
        rescue
          logger.error Time.zone.now.strftime("%Y-%m-%d %T") + " Person #{ep.id} failed for some reason!"
        end
      end
      puts Time.zone.now.strftime("%Y-%m-%d %T") + " Finished!"
    end
          

    def import(mis_id, options = {})
      mis_id = mis_id.id if mis_id.kind_of? Ebs::Person
      options.reverse_merge! Hash[Settings.ebs_import_options.split(",").map{|o| [o.to_sym,true]}]
      logger.info "Importing user #{mis_id}"
      if (ep = (Ebs::Person.find_by_person_code((mis_id.to_s.match(/\d{3}/) ? mis_id.to_s.tr('^0-9','') : mis_id)) or 
                Ebs::Person.where(Settings.ebs_username_field => mis_id.to_s).first
          ))
        @person = Person.find_by_mis_id(ep.id) || Person.new(:mis_id => ep.id)
        #@person.update_attribute(:tutor, ep.tutor ? Person.get(ep.tutor).id : nil) 
        if @person.new_record? or ep.updated_date.nil? or (@person.updated_at < ep.updated_date)
          @person.update_attributes(
            :forename      => ep.known_as.blank? ? ep.forename : ep.known_as,
            :surname       => ep.surname,
            :middle_names  => ep.middle_names && ep.middle_names.split,
            :address       => ep.address ? [ep.address.address_line_1,ep.address.address_line_2,
                              ep.address.address_line_3,ep.address.address_line_4].reject{|a| a.blank?} : [],
            :town          => ep.address ? ep.address.town : "",
            :postcode      => ep.address ? [ep.address.uk_post_code_pt1,ep.address.uk_post_code_pt2].join(" ") : "",
            # :photo         => Ebs::Blob.table_exists? && ep.blobs.photos.first.try(:binary_object),
            :photo         => Ebs::Blob.find_by_owner_ref(mis_id.to_s).try(:binary_object), 
            :mobile_number => ep.mobile_phone_number,
            :next_of_kin   => [ep.fes_next_of_kin, ep.fes_nok_contact_no].join(" "),
            :date_of_birth => ep.date_of_birth,
            #:uln           => ep.unique_learn_no,
            :mis_id        => ep.person_code,
            :staff         => ep.fes_staff_code?,
            :username      => (ep.send(Settings.ebs_username_field) or ep.id.to_s),
            :personal_email=> ep.personal_email,
            :home_phone    => ep.address && ep.address.telephone,
            :note          => (ep.note and ep.note.notes) ? (ep.note.notes + "\nLast updated by #{ep.note.updated_by or ep.note.created_by} on #{ep.note.updated_date or ep.note.created_date}") : nil,
            :contact_allowed => (Settings.ebs_no_contact.blank? || ep.send(Settings.ebs_no_contact) != "Y")
          )
          if @person.contact_allowed != (Settings.ebs_no_contact.blank? || ep.send(Settings.ebs_no_contact) != "Y")
            @person.update_attribute("contact_allowed", Settings.ebs_no_contact.blank? || ep.send(Settings.ebs_no_contact) != "Y")
            @person.save if options[:save] 
          end
        else
          puts Time.zone.now.strftime("%Y-%m-%d %T") + " [#{@person.mis_id}] #{@person.name} - Update not needed since #{@person.updated_at} >= #{ep.updated_date}"
        end
        @person.import_courses if options[:courses]
        @person.import_attendances if options[:attendances]
        @person.import_quals if options[:quals]
        @person.import_absences if options[:absences]
        # @person.import_absences
        @person.import_support_plps if options[:support_plps]
        return @person
      else
        return false
      end
    end

  def mis_search_for(query)
    Ebs::Person.search_for(query).order("surname,forename").limit(50).map{|p| import(p,:save => false, :people=> false)}
  end 

  def csv_import(files)
    old_logger_level, logger.level = logger.level, Logger::ERROR if logger
    files = [files] if files.kind_of? String
    files.each do |file|
      tname = File.basename(file, ".csv").downcase
      model = case tname
	      when "student_addresses" then "Address"
	      else tname.classify
              end
      model = "Ebs::#{model}".constantize
      print "#{tname}: "
      unless File.file? file
        print "File not found! Skipping ...\n"
	next
      end
      if Ebs::Model.connection.table_exists? tname
        print "Table exists\n"
      else 
	print "Creating table\n"
	csv = CSV.open file, :encoding => "ISO-8859-1"
        cols = csv.shift.map{|col| col.try(:downcase)}
	Ebs::Model.connection.create_table tname, {:id => false} do |t|
          cols.each {|h| t.send(h == "id" ? "integer" : "string",h, {:limit => 65535})}
        end
	csv.each do |row|
          hsh = Hash[cols.zip row.map{|x| x.try(:encode)}]
          a = model.new(hsh)
          a.id = hsh[model.primary_key]
	  a.save
	  puts Time.zone.now.strftime("%Y-%m-%d %T") + " Added #{a.class.name} ##{a.id}"
        end
      end
    end
  ensure
    logger.level = old_logger_level if logger
  end

  end

  # Instance methods

  def timetable_events(options = {})
    reds = if options == :next
      Ebs::RegisterEventDetailsSlot.where(:object_id => mis_id, :object_type => ['L','T']).
        where("planned_start_date > ?",Time.now).
        order(:planned_start_date).limit(1)
    else
      from = (options[:from] || Date.today.beginning_of_week)#.strftime("%Y-%d-%m %H:%M:%S")
      to   = (options[:to  ] || from.end_of_week)#.strftime("%Y-%d-%m %H:%M:%S")
      Ebs::RegisterEventDetailsSlot.where(:object_id => mis_id, :object_type => ['L','T'], :planned_start_date => from..to)
    end
    reds.map do |s| 
      t = TimetableEvent.new
      t.mis_id          = s.register_event_id
      t.title           = s.description.split(/\[/).first
      t.timetable_start = s.actual_start_date || s.planned_start_date
      t.timetable_end   = s.actual_end_date   || s.planned_end_date
      t.mark            = s.usage_code
      t.status          = s.status
      t.rooms           = s.rooms.map{|r| r.room_code}
      t.teachers        = s.teachers.map{|t| t.try(:name)}
      t
    end
  end

  def import_courses
    return self unless mis.people_units.any?
    #last_update = ( (person_courses.order("updated_at DESC").first.try(:updated_at) ) || ( Date.today - 5.years) )
    #mis_person.people_units.where("updated_date > ?",last_update).order("progress_date").each do |pu|
    mis_person.people_units.order("unit_type, progress_date").each do |pu|
      next unless pu.uio_id
      course = Course.import(pu.uio_id,{:people => false})
      next unless course
      # pc= PersonCourse.find_or_create_by_person_id_and_course_id(id,course.id)
      pc= PersonCourse.find_or_create_by(:person_id => id, :course_id => course.id)
      # pc = PersonCourse.where(:person_id => id, :course_id => course.id).first_or_create
      if pu.unit_type == "A" 
        pc.update_attributes({:status => :not_started,
                              :start_date       => pu.unit_instance_occurrence.qual_start_date,
                              :application_date => pu.created_date,
                              :tutorgroup => pu.tutorgroup,
                              :mis_status => pu.status},
                             {:without_protection => true}
                            )
      elsif pu.unit_type == "R"
        pc.update_attributes({:enrolment_date => pu.created_date,
                              :start_date     => pu.unit_instance_occurrence.qual_start_date,
                              :status => Ilp2::Application.config.mis_progress_codes[pu.progress_code],
                              :tutorgroup => pu.tutorgroup,
                              :mis_status => pu.status,
                              :end_date => [:complete,:incomplete].include?(Ilp2::Application.config.mis_progress_codes[pu.progress_code]) ? pu.progress_date : pu.unit_instance_occurrence.qual_end_date},
                             {:without_protection => true}
                            )
      end
    end
    # remove status of any course removed from the Student Record System, but still keep course info.
    PersonCourse.find_all_by_person_id( Person.find_by_mis_id( mis_person.person_code ).id ).each do |pc|
      next unless pc.course_id
      begin
        course = Course.find(pc.course_id)
      rescue ActiveRecord::RecordNotFound
        course = nil
      end
      next unless !course.nil? && course.mis_id
      pu = mis_person.people_units.find_by_uio_id(course.mis_id)
      if pu.nil?
        if ( !( pc.status.nil? && pc.mis_status.nil? ) )
          pc.update_attributes({:status => nil,
                                :mis_status => nil},
                               {:without_protection => true}
                              )
          pc.save
        end
      end
    end
    return self
  end

  def import_attendances
    settings_attendance_table=Settings.attendance_table
    settings_attendance_week_column=Settings.attendance_week_column
    settings_attendance_culm_column=Settings.attendance_culm_column
    settings_attendance_date_column=Settings.attendance_date_column
    settings_attendance_type_column=Settings.attendance_type_column
    # to turn on debug output:
    # ActiveRecord::Base.logger = Logger.new STDOUT
    if [settings_attendance_table,settings_attendance_week_column,settings_attendance_culm_column,settings_attendance_date_column].detect{|x| x.blank?}
      logger.error "Attendance table not configured"
      return false
    end
    last_date = unless attendances.empty?
      attendances.last.week_beginning
    else
      Date.civil(1900,1,1)
    end
    mis_person.attendances.
      where("#{Settings.attendance_date_column} > ? and #{Settings.attendance_date_column} < ?",(last_date - 2.weeks),Date.tomorrow).#strftime("%Y-%d-%m %H:%M:%S")).
      # where("1=1").
      each do |att|
        next unless att.send(settings_attendance_date_column)
        next unless att.send(settings_attendance_culm_column)
        course_type = settings_attendance_type_column.blank? ? "overall" : (att.send(settings_attendance_type_column) || "overall").downcase
        na=Attendance.find_or_create_by_person_id_and_week_beginning_and_course_type(id,att.send(settings_attendance_date_column),course_type)
# =begin
        na.update_attributes(
          :week_beginning => att.send(settings_attendance_date_column),
          :att_year    => att.send(settings_attendance_culm_column),
          :att_week    => att.send(settings_attendance_week_column),
          :course_type => settings_attendance_type_column.blank? ? "overall" : (att.send(settings_attendance_type_column) || "overall").downcase
        )
# =end
      end
    return self
  end

  def import_quals
    last_update = ( qualifications.order("updated_at DESC").first.try(:updated_at) ) || ( Date.today - 5.years )
    mis_person.learner_aims.where("uio_id IS NOT NULL and grade IS NOT NULL and updated_date > ? and upper(learning_aim) not like 'Z%%' and upper(learning_aim) != 'ENRICH'",last_update).each do |la|
      next unless la.unit_instance_occurrence 
      next unless Qualification.where(:mis_id => la.id, "import_type" => "la").empty?
      nq=qualifications.create(
        :title       => la.unit_instance_occurrence.title,
        :grade       => la.grade,
        :person_id   => id,
        :created_at  => la.exp_end_date,
        :predicted   => false,
        :import_type => "la"
      )
      nq.update_attribute("mis_id",la.id)
    end
    mis_person.attainments.where("NOT (upper(description) LIKE '%%NOT APPLICABLE%%' and source = 'PLR data') and upper(grade) NOT LIKE 'NA%%' and upper(grade) NOT LIKE 'OTH%%' and upper(grade) NOT LIKE '%%UNCLASSIFIED%%' and upper(grade) NOT LIKE '%%NO SHOW%%' and upper(grade) NOT LIKE '%%P ALPHA-NUMERIC VALUE%%' and upper(grade) != '01' and regexp_like(trim(fes_qualification_aim), '^[0-9]')").each do |at|
      next unless Qualification.where(:mis_id => at.id, "import_type" => "attainment").empty?
      nq=qualifications.create(
        :title       => at.description,
        :grade       => at.grade,
        :person_id   => id,
        :created_at  => at.date_awarded,
        :predicted   => false,
        :import_type => "attainment"
      )
      nq.update_attribute("mis_id",at.id)
      nq.events.first.update_attribute("event_date",at.date_awarded || at.created_date)
    end
  end

  def import_absences
    Ebs::Absence.find_all_by_person_id(mis_id).each do |a|
      register_event_details_slot_ids = []
      register_event_details_slot_dates = []      
      a.absence_slots.each do |as|
        register_event_details_slot_ids << as.register_event_details_slot_id
      end
      register_event_details_slot_ids.each do |redsi|
        if Ebs::RegisterEventDetailsSlot.where(id: redsi).exists?
          register_event_details_slot_dates << Ebs::RegisterEventDetailsSlot.where(id: redsi)[0].planned_start_date
        end
      end
      register_event_details_slot_dates.compact!
      start_date = ''
      end_date = ''
      if (register_event_details_slot_dates.size > 0)
        # start_date = register_event_details_slot_dates.min.nil? ? '' : register_event_details_slot_dates.min
        # end_date = register_event_details_slot_dates.max.nil? ? '' : register_event_details_slot_dates.max
        start_date = register_event_details_slot_dates.min
        end_date = register_event_details_slot_dates.max        
      end
      next if absences.detect{|ab| a.created_at == ab.created_at}
      next unless a.notified_at
      na = absences.create(
        :body => a.reason_extra,
        :category => a.reason,
        :usage_code => a.usage_code,
        :created_at => a.created_at,
        :lessons_missed => a.absence_slots_count,
        :contact_category => a.contact,
        :notified_at => a.notified_at,
        :start_date => start_date,
        :end_date => end_date
      )
    end
  end

  def import_support_plps
    Ebs::Person.find_all_by_person_code(mis_id).each do |p|
      [
        # [0] field name, [1] title, [2] verifiers domain (optional), [3] values exclude list (optional)

        ["fes_user_39","IAG Appointment"], # 23 appointments set in EBS for 15/16 - will not be populated anymore

        ## ["fes_user_29","Bursary Start Date"], # 1 date for 15/16 - cannot be used? - will become Young Adult Carers currently not in EBS - MD looking at pulling in
        ## ["fes_user_30","Bursary End Date"], # 1 date for 15/16 - cannot be used?
        # Bursary info from FAM fields in EBS - populated from spreadsheet from PayMyStudent

        ["fes_user_21","Car Park Permit Number"], # will be cleared down and set to: FULL,AUTUMN,SPRING,SUMMER
        ["fes_user_26","Bus Pass Region","U_BUSPASS_REGION"], # cleared out each year for ready for new acyr!

        ["fes_user_36","Free College Meals", "U_YESNO",["N"]], # populated by MD
        # ["fes_user_38","FCM Funding","U_FSM_FUNDING"], # ignore - meaningless for requirement

        ["fes_user_14","Special Care Guidance","U_SPECIALCARE"], # VL: care leavers
        ["fes_user_18","EHC Plan","U_EHCP",["N"]], # VL: currently Yes No Pending - will be change to type EHCP,HighNeeds,EHCPHN
        # ["fes_user_19","Additional Learning Sup","U_ALS_REQ",["NO"]], # not used as would water down VL indicator
        ["fes_user_35","HE Care Leaver","U_HECARE",["05","98","99"]], # VL:
        ["fes_user_40","Social Worker"] # VL: if has social worker?
      ].each do |f|
        v = p.send(f[0])
        # next if support_plps.find{ |sp| sp.name == f[1] && sp.active != 0 && sp.value == v }
        # next if support_plps.exists?( :name => f[1], :active => 1, :value => v )
        support_plps_for_name = support_plps.find{ |sp| sp.name == f[1] && sp.active == true }
        next if support_plps_for_name.present? && support_plps_for_name.try(:value) == v
        support_plps.update_all( ["active = 0, updated_at = ?",DateTime.now], ["active != 0 and name = ? and ( value != ? or ? is null)", f[1], v, v ] ) unless support_plps.nil?
        ver_info = ( f[2].present? ? Ebs::Verifier.find_by_low_value_and_rv_domain(v,f[2]) : nil )
        if v.present?
          nsp = support_plps.create(
            :name => f[1],
            :value => v,
            :description => ( ver_info.present? ? ver_info.try(:fes_long_description) : nil ),
            :short_description => ( ver_info.present? ? ver_info.try(:fes_short_description) : nil ),
            :active => 1,
            :domain => "EBS",
            :source => "people." + f[0]
          ) unless v.nil? || (f[3].present? && f[3].include?(v))
        end
      end
    end
  end

end

module MisCourse

  def self.included receiver
    receiver.extend ClassMethods
    receiver.belongs_to :mis, :class_name => "Ebs::UnitInstanceOccurrence", :foreign_key => :mis_id
    receiver.belongs_to :mis_course, :class_name => "Ebs::UnitInstanceOccurrence", :foreign_key => :mis_id
  end

  def import_people
    last_update = ( person_courses.order("updated_at DESC").first.try(:updated_at) ) || ( Date.today - 5.years )
    mis_course.people_units.order("progress_date").each do |pu|
    #mis_course.people_units.where("updated_date > ?",last_update).order("progress_date").each do |pu|
      person = Person.import(pu.person_code, {:courses => false})
      pc= PersonCourse.find_or_create_by_person_id_and_course_id(person.id,id)
      if pu.unit_type == "A" 
        pc.update_attributes({:status => :not_started,
                              :start_date       => pu.unit_instance_occurrence.qual_start_date,
                              :application_date => pu.created_date,
                              :tutorgroup => pu.tutorgroup,
                              :mis_status => pu.status},
                             {:without_protection => true}
                            )
      elsif pu.unit_type == "R"
        pc.update_attributes({:enrolment_date => pu.created_date,
                              :start_date     => pu.unit_instance_occurrence.qual_start_date,
                              :tutorgroup => pu.tutorgroup,
                              :status => Ilp2::Application.config.mis_progress_codes[pu.progress_code],
                              :end_date => pu.progress_date,
                              :mis_status => pu.status},
                             {:without_protection => true}
                            ) unless pc.status == :not_started
      end
    end
    return self
  end

  def timetable_events(options = {})
    reds = if options == :next
      Ebs::RegisterEventDetailsSlot.where(:object_id => mis_id, :object_type => 'U').
        where("planned_start_date > ?", Time.now).
        order(:planned_start_date).limit(1)
    else
      from = (options[:from] || Date.today.beginning_of_week)#.strftime("%Y-%d-%m %H:%M:%S")
      to   = (options[:to  ] || from.end_of_week)#.strftime("%Y-%d-%m %H:%M:%S")
      Ebs::RegisterEventDetailsSlot.where(:object_id => mis_id, :object_type => 'U', :planned_start_date => from..to)
    end
    reds.map do |s| 
      t = TimetableEvent.new 
      t.mis_id          = s.register_event_id,
      t.title           = s.description.split(/\[/).first,
      t.timetable_start = s.actual_start_date || s.planned_start_date,
      t.timetable_end   = s.actual_end_date   || s.planned_end_date,
      t.mark            = s.usage_code,
      t.status          = s.status,
      t.rooms           = s.rooms.map{|r| r.room_code},
      t.teachers        = s.teachers.map{|t| t.try(:name)}
    end
  end

  module ClassMethods

    def mis_search_for(query)
      Ebs::UnitInstanceOccurrence.search_for(query).order( "calocc_occurrence_code desc, long_description" ).limit(50).map{|p| import(p.uio_id,:save => false, :courses => false)}
    end 

    def import(mis_id, options = {})
      options.reverse_merge! :save => true, :people => false
      if (ec = Ebs::UnitInstanceOccurrence.find_by_uio_id(mis_id))
        @course = Course.find_or_create_by_mis_id(mis_id)
        @course.update_attributes(
          :title  => ec.title,
          :code   => ec.fes_uins_instance_code,
          :year   => ec.calocc_occurrence_code,
          :mis_id => mis_id,
          :vague_title => ec.send(Settings.application_title_field)
          # :vague_title => Settings.application_title_field
        )
        if @course.vague_title != (ec.send(Settings.application_title_field))
        # if @course.vague_title != Settings.application_title_field
          @course.update_attribute("vague_title",ec.send(Settings.application_title_field)) # unless Settings.application_title_field.blank?
          # @course.update_attribute("vague_title", Settings.application_title_field)
          @course.save if options[:save]
        end
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

module MisPersonCourse
  def mis
    Ebs::PeopleUnit.find_by_uio_id_and_person_code(course.mis_id,person.mis_id)
  end
end
