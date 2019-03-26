class AbsencesController < ApplicationController

  def create
    if @user.admin?
      params[:reg_ids] = JSON.parse params[:reg_ids]
      params[:reg_ids][0] = params[:reg_ids][0].map {|id| id.to_i}
      params[:absence][:created_by] = @topic.id.to_s
      params[:absence][:notified_at] = params[:absence][:notified_at] + ' ' + params[:absence][:hours] + ':' + params[:absence][:mins]

      params[:absence][:reason] = params[:absence][:category]
      params[:absence][:reason_extra] = params[:absence][:body]
      params[:absence][:contact] = params[:absence][:contact_category]

      @absence = Ebs::Absence.new(params[:absence])
      # @absence.save!
      @absence.create_or_update

      slot_ids = []

      params[:reg_ids][0].each do |ri|
        index = params[:reg_ids][0].index(ri)
        slot_date = params[:reg_ids][1][index]
        slot = Ebs::RegisterEventDetailsSlot.where(planned_start_date: slot_date, object_id: @absence.person_id, register_event_id: ri)[0]
        if slot.respond_to?(:id)
          slot_ids << slot.id
        end
      end

      learner = Ebs::Person.find(@absence.person_id)

      all_teachers = {}
      slot_ids.each do |si|
        @absence_slot = Ebs::AbsenceSlot.new(absence_id: @absence.id, register_event_details_slot_id: si)
        # @absence_slot.save!
        @absence_slot.create_or_update
        slot = Ebs::RegisterEventDetailsSlot.where(id: si)[0]
        slot.usage_code = @absence.usage_code
        # slot.save!
        slot.create_or_update

        teachers = []
        teacher_slots = Ebs::RegisterEventDetailsSlot.where(planned_start_date: slot.planned_start_date, register_event_id: slot.register_event_id, object_type: 'T')
        teacher_slots.each do |ts|
          teacher = Ebs::Person.find(ts.object_id)
          teachers << teacher
        end

        register_event = Ebs::RegisterEvent.find(slot.register_event_id)
        teachers.each do |t|
          all_teachers[t.person_code] = [].to_set if ! all_teachers.include?(t.person_code)
          all_teachers[t.person_code] << { :regevent => register_event, :slot => slot }
        end
      end

      all_teachers.each do |t,details|
        teacher = Ebs::Person.find(t)
        regevents_and_slots_sorted = details.to_a.sort_by{|ras| [ras[:slot].planned_start_date, ras[:slot].planned_end_date] }
        TeacherMailer.email_teacher_regevents_and_slots(teacher, learner, regevents_and_slots_sorted).deliver if (regevents_and_slots_sorted.try(:count) || 0) > 0
      end

      redirect_to person_timetables_url person_id: @absence.person_id, date: (params[:absence] && params[:absence][:date] && params[:absence][:date].to_date.is_a?(Date) == true) ? (params[:absence][:date]) : (nil), refresh: true
    end
  end

end
