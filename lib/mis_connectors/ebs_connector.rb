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

    def resync(yr)
      count = skipcount = 0
      Ebs::Person.find_each(:include => :people_units) do |ep|
        begin
	  skipcount +=1
          next unless ep.people_units.detect{|pc| pc.calocc_code == yr} if yr
          puts "#{count}:\tskip #{skipcount}\timport #{import(ep).name}"
          count += 1
	  skipcount = 0
        rescue
          logger.error "Person #{ep.id} failed for some reason!"
        end
      end
      puts "Finished!"
    end
          

    def import(mis_id, options = {})
      mis_id = mis_id.id if mis_id.kind_of? Ebs::Person
      # NOTE: Need to change these defaults after launch
      options.reverse_merge! Hash[Settings.ebs_import_options.split(",").map{|o| [o.to_sym,true]}]
      logger.info "Importing user #{mis_id}"
      if (ep = (Ebs::Person.find_by_person_code((mis_id.to_s.match(/\d{6}/) ? mis_id.to_s.tr('^0-9','') : mis_id)) or 
                Ebs::Person.find_by_college_login(mis_id) or 
                Ebs::Person.find_by_network_userid(mis_id)
          ))
        @person = Person.find_or_create_by_mis_id(ep.id)
        @person.update_attribute(:tutor, ep.tutor ? Person.get(ep.tutor).id : nil) 
        @person.update_attributes(
          :forename      => ep.forename,
          :surname       => ep.surname,
          :middle_names  => ep.middle_names && ep.middle_names.split,
          :address       => ep.address ? [ep.address.address_line_1,ep.address.address_line_2,
                             ep.address.address_line_3,ep.address.address_line_4].reject{|a| a.blank?} : [],
          :town          => ep.address ? ep.address.town : "",
          :postcode      => ep.address ? [ep.address.uk_post_code_pt1,ep.address.uk_post_code_pt2].join(" ") : "",
          :photo         => Ebs::Blob.table_exists? && ep.blobs.photos.first.try(:binary_object),
          :mobile_number => ep.mobile_phone_number,
          :next_of_kin   => [ep.fes_next_of_kin, ep.fes_nok_contact_no].join(" "),
          :date_of_birth => ep.date_of_birth,
          :uln           => ep.unique_learn_no,
          :mis_id        => ep.person_code,
          :staff         => ep.fes_staff_code?,
          :username      => (ep.network_userid or ep.college_login or ep.id),
          :personal_email=> ep.personal_email,
          :home_phone    => ep.address && ep.address.telephone,
          :note          => (ep.note and ep.note.notes) ? (ep.note.notes + "\nLast updated by #{ep.note.updated_by or ep.note.created_by} on #{ep.note.updated_date or ep.note.created_date}") : nil
        )
        @person.save if options[:save] 
        @person.import_courses if options[:courses]
        @person.import_attendances if options[:attendances]
        @person.import_quals if options[:quals]
        @person.import_absences if options[:absences]
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
	  puts "Added #{a.class.name} ##{a.id}"
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
        :title        => s.description.split(/\[/).first,
        :start        => s.actual_start_date || s.planned_start_date,
        :end          => s.actual_end_date   || s.planned_end_date,
        :mark         => s.usage_code,
        :status       => s.status,
        :rooms        => s.rooms.map{|r| r.room_code},
        :teachers     => s.teachers.map{|t| t.try(:name)}
      )
    end
  end

  def import_courses
    mis_person.people_units.order("progress_date").each do |pu|
      next unless pu.uio_id
      course = Course.import(pu.uio_id,{:people => false})
      pc= PersonCourse.find_or_create_by_person_id_and_course_id(id,course.id)
      if pu.unit_type == "A" 
        pc.update_attributes({:status => :not_started,
                              :start_date       => pu.unit_instance_occurrence.qual_start_date,
                              :application_date => pu.created_date,
                              :mis_status => pu.status},
                             {:without_protection => true}
                            )
      elsif pu.unit_type == "R"
        pc.update_attributes({:enrolment_date => pu.created_date,
                              :start_date     => pu.unit_instance_occurrence.qual_start_date,
                              :status => Ilp2::Application.config.mis_progress_codes[pu.progress_code],
                              :mis_status => pu.status,
                              :end_date => [:complete,:incomplete].include?(Ilp2::Application.config.mis_progress_codes[pu.progress_code]) ? pu.progress_date : pu.unit_instance_occurrence.qual_end_date},
                             {:without_protection => true}
                            )
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
      where("start_week > ?",last_date - 2.weeks).
      each do |att|
        na=Attendance.find_or_create_by_person_id_and_week_beginning(id,att.start_week)
        na.update_attributes(
          :week_beginning => att.start_week,
          :att_year   => att.attendance,
          :att_3_week => att.attendance_last3wks,
          :att_week   => att.attendance_weekly
        )
      end
    return self
  end

  def import_quals
    mis_person.learner_aims.each do |la|
      next unless la.unit_instance_occurrence && la.grade
      next unless Qualification.where(:mis_id => la.id).empty?
      nq=qualifications.create(
        :title      => la.unit_instance_occurrence.long_description,
        :grade      => la.grade,
        :person_id  => id,
        :created_at => la.exp_end_date,
        :predicted  => false
      )
      nq.update_attribute("mis_id",la.id)
    end
    return self
  end

  def import_absences
    Ebs::Absence.find_all_by_person_id(mis_id).each do |a|
      next if absences.detect{|ab| a.notified_at == ab.created_at}
      na = absences.create(
        :body => a.reason_extra,
        :category => a.reason,
        :usage_code => a.usage_code,
        :created_at => a.notified_at,
        :lessons_missed => a.absence_slots_count,
        :contact_category => a.contact
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
    mis_course.people_units.order("progress_date").each do |pu|
      person = Person.import(pu.person_code, {:courses => false})
      pc= PersonCourse.find_or_create_by_person_id_and_course_id(person.id,id)
      if pu.unit_type == "A" 
        pc.update_attributes({:status => :not_started,
                              :start_date       => pu.unit_instance_occurrence.qual_start_date,
                              :application_date => pu.created_date,
                              :mis_status => pu.status},
                             {:without_protection => true}
                            )
      elsif pu.unit_type == "R"
        pc.update_attributes({:enrolment_date => pu.created_date,
                              :start_date     => pu.unit_instance_occurrence.qual_start_date,
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
      from = options[:from] || Date.today.beginning_of_week
      to   = options[:to  ] || from.end_of_week
      Ebs::RegisterEventDetailsSlot.where(:object_id => mis_id, :object_type => 'U', :planned_start_date => from..to)
    end
    reds.map do |s| 
      TimetableEvent.create(
        :mis_id       => s.register_event_id,
        :title        => s.description.split(/\[/).first,
        :start        => s.actual_start_date || s.planned_start_date,
        :end          => s.actual_end_date   || s.planned_end_date,
        :mark         => s.usage_code,
        :status       => s.status,
        :rooms        => s.rooms.map{|r| r.room_code},
        :teachers     => s.teachers.map{|t| t.try(:name)}
      )
    end
  end

  module ClassMethods

    def mis_search_for(query)
      Ebs::UnitInstanceOccurrence.search_for(query).limit(50).map{|p| import(p,:save => false, :courses => false)}
    end 

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
        @course.update_attribute("vague_title",ec.send(Settings.application_title_field)) unless Settings.application_title_field.blank?
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

module MisPersonCourse
  def mis
    Ebs::PeopleUnit.find_by_uio_id_and_person_code(course.mis_id,person.mis_id)
  end
end
