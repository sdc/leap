class TeacherMailer < ActionMailer::Base
  default from: Settings.absence_line_email

  def email_teacher(teacher, learner, register_event, slot)
  	if teacher.present? && teacher.college_email.present?
	    @teacher = teacher
	    @learner = learner
	    @register_event = register_event
	    @slot = slot
	    mail_to = @teacher.college_email
	    mail_to = Settings.dev_test_email if Rails.env == 'development' && Settings.dev_send_to_test_email == 'on' && Settings.dev_test_email.present?
	    # mail(to: @teacher.college_email, subject: 'Student Absence') if !( Rails.env == 'development' or ( Person.user.superuser? and Settings.su_send_emails != 'on' ) )
	    mail(to: mail_to, subject: 'Student Absence') if !( ( Rails.env == 'development' && Settings.dev_send_to_test_email != 'on' ) or ( Person.user.superuser? and Settings.su_send_emails != 'on' ) )
	  end
  end

  def email_teacher_regevents_and_slots(teacher, learner, regevents_and_slots)
    return if (!teacher.present?) || teacher.college_email.empty?

    @teacher = teacher
    @learner = learner
    @register_event_slots = regevents_and_slots
    mail_to = @teacher.college_email
    mail_to = Settings.dev_test_email if Rails.env == 'development' && Settings.dev_send_to_test_email == 'on' && Settings.dev_test_email.present?
    mail(to: mail_to, subject: 'Student Absence') if !( ( Rails.env == 'development' && Settings.dev_send_to_test_email != 'on' ) or ( Person.user.superuser? and Settings.su_send_emails != 'on' ) )

  end

end
