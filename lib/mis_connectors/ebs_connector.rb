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
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

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
      # NOTE: Need to change these defaults after launch
      options.reverse_merge! :save => true, :courses => true, :attendances => true, 
                             :quals => true, :support_history => true, :support_requests => true, :targets => true
      logger.info "Importing user #{mis_id}"
      if (ep = (Ebs::Person.find_by_person_code(mis_id) or Ebs::Person.find_by_network_userid(mis_id)))
        @person = Person.find_or_create_by_mis_id(ep.id)
        @person.update_attributes(
          :forename      => ep.forename,
          :surname       => ep.surname,
          :middle_names  => ep.middle_names && ep.middle_names.split,
          :address       => ep.address ? [ep.address.address_line_1,ep.address.address_line_2,
                             ep.address.address_line_3,ep.address.address_line_4].reject{|a| a.blank?} : [],
          :town          => ep.address ? ep.address.town : "",
          :postcode      => ep.address ? [ep.address.uk_post_code_pt1,ep.address.uk_post_code_pt2].join(" ") : "",
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
        @person.import_targets if options[:targets]
        @person.import_support_history if options[:support_history]
        @person.import_support_requests if options[:support_requests]
        return @person
      else
        return false
      end
    end

  def mis_search_for(query)
    Ebs::Person.search_for(query).order("surname,forename").limit(50).map{|p| import(p,:save => false, :courses => false)}
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
      next unless pu.uio_id
      course = Course.get(pu.uio_id)
      pc= PersonCourse.find_or_create_by_person_id_and_course_id(id,course.id)
      if pu.unit_type == "A" 
        pc.update_attributes(:status => :not_started,
                             :application_date => pu.created_date
                            )
      elsif pu.unit_type == "R"
        pc.update_attributes(:enrolment_date => pu.created_date,
                             :start_date     => pu.unit_instance_occurrence.qual_start_date,
                             :status => Ilp2::Application.config.mis_progress_codes[pu.progress_code],
                             :end_date => [:complete,:incomplete].include?(Ilp2::Application.config.mis_progress_codes[pu.progress_code]) ? pu.progress_date : nil) unless pc.status == :not_started
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

  # Tese are an SDC-only imports for moving from eilp1 - I will probably delete
  # them once we've launched

  def import_support_history
    Ebs::SupportNote.find_all_by_person_id(mis_id).each do |n|
      next unless n.tick
      next if n.notes.blank?
      next if support_histories.detect{|h| h.category == n.support_note_title}
      support_histories.create(
        :category      => n.support_note_title,
        :body          => n.notes,
        :created_at    => n.created_at,
        :created_by_id => Person.first.id
      )
    end
  end

  def import_support_requests
    Ebs::SupportRequest.find_all_by_person_id(mis_id).each do |r|
      next if r.difficulty.nil? or r.difficulty.empty?
      next if support_requests.detect{|s| s.created_at == r.created_at}
      support_requests.create(
        :sessions => r.res,
        :difficulties  => r.difficulty,
        :created_at    => r.created_at,
        :created_by_id => Person.get(r.created_by).id
      )
    end
  end

  def import_targets
    Ebs::Target.find_all_by_person_id(mis_id).each do |t|
      next if t.target.blank?
      next if targets.detect{|nt| t.created_at == nt.created_at}
      nt = targets.create(
        :body => t.target,
        :actions => t.action,
        :target_date => t.target_date,
        :complete_date => t.completed_at,
        :created_by_id => t.person_id,
        :created_at    => t.created_at
      )
      nt.notify_complete if nt.complete_date
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
