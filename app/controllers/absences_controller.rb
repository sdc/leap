class AbsencesController < ApplicationController
  def create
    params[:reg_ids] = JSON.parse params[:reg_ids]
    params[:reg_ids][0] = params[:reg_ids][0].map {|id| id.to_i}
    params[:absence][:created_by] = @topic.id.to_s
    params[:absence][:notified_at] = params[:absence][:notified_at] + ' ' + params[:absence][:hours] + ':' + params[:absence][:mins]

    params[:absence][:reason] = params[:absence][:category]
    params[:absence][:reason_extra] = params[:absence][:body]
    params[:absence][:contact] = params[:absence][:contact_category]

    @absence = Ebs::Absence.new(params[:absence])
    @absence.save!

    slot_ids = []

    params[:reg_ids][0].each do |ri|
      index = params[:reg_ids][0].index(ri)
      slot_date = params[:reg_ids][1][index]
      slot = Ebs::RegisterEventDetailsSlot.where(planned_start_date: slot_date, object_id: @absence.person_id, register_event_id: ri)[0]
      slot_ids << slot.id
    end

    slot_ids.each do |si|
      @absence_slot = Ebs::AbsenceSlot.new(absence_id: @absence.id, register_event_details_slot_id: si)
      @absence_slot.save!
      slot = Ebs::RegisterEventDetailsSlot.where(id: si)[0]
      slot.usage_code = @absence.usage_code
      slot.save!
      if Rails.env == "development"
        teacher = Ebs::Person.find(30141843)
      else
        teacher = Ebs::Person.find(Ebs::RegisterEventDetailsSlot.where(planned_start_date: slot.planned_start_date, register_event_id: slot.register_event_id, object_type: 'T')[0].object_id)
      end
      register_event = Ebs::RegisterEvent.find(slot.register_event_id)
      learner = Ebs::Person.find(slot.object_id)
      TeacherMailer.email_teacher(teacher, learner, register_event, slot).deliver
    end

    redirect_to "/people/#{@absence.person_id}/timetables?refresh=true"
  end

end
