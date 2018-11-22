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

      # @absence = Ebs::Absence.new(params[:absence])
      @absence = Ebs::Absence.new(ebs_absence_params)
      @absence.save!

      slot_ids = []

      params[:reg_ids][0].each do |ri|
        index = params[:reg_ids][0].index(ri)
        slot_date = params[:reg_ids][1][index]
        slot = Ebs::RegisterEventDetailsSlot.where(planned_start_date: slot_date, object_id: @absence.person_id, register_event_id: ri)[0]
        if slot.respond_to?(:id)
          slot_ids << slot.id
        end
      end

      slot_ids.each do |si|
        # @absence_slot = Ebs::AbsenceSlot.new(absence_id: @absence.id, register_event_details_slot_id: si)
        @absence_slot = Ebs::AbsenceSlot.new(absence_slot_params(absence_id: @absence.id, register_event_details_slot_id: si))
        @absence_slot.save!
        slot = Ebs::RegisterEventDetailsSlot.where(id: si)[0]
        # slot.usage_code = @absence.usage_code
        slot.update(register_event_details_slot_params(usage_code: @absence.usage_code))
        slot.save!
        if Rails.env == "development"
          teachers = []
          teacher = Ebs::Person.find(@topic.mis_id)
          teachers << teacher
        else
          teachers = []
          teacher_slots = Ebs::RegisterEventDetailsSlot.where(planned_start_date: slot.planned_start_date, register_event_id: slot.register_event_id, object_type: 'T')
          teacher_slots.each do |ts|
            teacher = Ebs::Person.find(ts.object_id)
            teachers << teacher
          end
        end
        register_event = Ebs::RegisterEvent.find(slot.register_event_id)
        learner = Ebs::Person.find(slot.object_id)
        if teachers.count > 0
          teachers.each do |t|
            TeacherMailer.email_teacher(t, learner, register_event, slot).deliver
          end
        end
      end
      redirect_to person_timetables_url person_id: @absence.person_id, date: (params[:absence] && params[:absence][:date] && params[:absence][:date].to_date.is_a?(Date) == true) ? (params[:absence][:date]) : (nil), refresh: true
    end
  end

  def create_leap_absence(params_passed)
    params = absence_params(params_passed)
  end

  private

    def absence_params(params_passed)
      params = ActionController::Parameters.new(absence: params_passed)
      params.require(:absence).permit(:lessons_missed, :category, :body, :usage_code, :notified_at, :contact_category, :created_at, :deleted, :from_date, :person_id, :created_by_id, :updated_at, :start_date, :end_date)
    end

    def ebs_absence_params
      # params.require(:absence).permit(:lessons_missed, :category, :body, :usage_code, :notified_at, :contact_category, :created_at, :deleted, :from_date, :person_id, :created_by_id, :updated_at, :start_date, :end_date, :hours, :mins, :date, :created_by, :reason, :reason_extra, :contact)
      params.require(:absence).permit(:lessons_missed, :usage_code, :notified_at, :created_at, :deleted, :from_date, :person_id, :created_by_id, :updated_at, :start_date, :end_date?, :created_by, :reason, :reason_extra, :contact)
    end  

    def absence_slot_params(params_passed)
      params = ActionController::Parameters.new(absence_slot: params_passed)
      params.require(:absence_slot).permit(:absence_id, :register_event_details_slot_id)
    end

    def register_event_details_slot_params(usage_code)
      params = ActionController::Parameters.new(register_event_details_slot: usage_code)
      params.require(:register_event_details_slot).permit(:usage_code)
    end
end
