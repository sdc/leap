class AbsencesController < ApplicationController
  def create
    binding.pry
    params[:reg_ids] = JSON.parse params[:reg_ids]
    params[:reg_ids][0] = params[:reg_ids][0].map {|id| id.to_i}
    params[:absence][:created_by] = @topic.id.to_s
    params[:absence][:notified_at] = params[:absence][:notified_at] + ' ' + params[:absence][:hours] + ':' + params[:absence][:mins]

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
    end

    redirect_to "/people/#{@absence.person_id}/timetables?refresh=true"
  end


end
