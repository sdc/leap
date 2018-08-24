class TeacherMailer < ActionMailer::Base
  default from: "leap@southdevon.ac.uk"

  def email_teacher(teacher, learner, register_event, slot)
    @teacher = teacher
    @learner = learner
    @register_event = register_event
    @slot = slot
    mail(to: @teacher.college_email, subject: 'Student Absence')
  end 
    
end
