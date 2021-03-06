class TeacherMailer < ActionMailer::Base
  default from: Settings.absence_line_email

  def email_teacher(teacher, learner, register_event, slot)
  	if teacher.present? && teacher.college_email.present?
	    @teacher = teacher
	    @learner = learner
	    @register_event = register_event
	    @slot = slot
	    mail(to: @teacher.college_email, subject: 'Student Absence') if !( Rails.env == 'development' or ( Person.user.superuser? and Settings.su_send_emails != 'on' ) )
	  end
  end 
    
end
