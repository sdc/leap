class TeacherMailer < ActionMailer::Base
  default from: "leap@southdevon.ac.uk"

  def email_teacher(teacher)
    @teacher = teacher
    mail(to: @teacher.college_email, subject: 'Sample Email')
  end 
    
end
