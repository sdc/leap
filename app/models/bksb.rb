class BKSB < ActiveResource::Base

# Look, this happens in an odd way. I rewrite element_path so it points to all the 
# results for a person. You pass in the person code as the id. So, yes, Rails would
# expect a single result but actually gets a load of results in the format BKSB
# presents them. But as long as I parse these out and create the Qualification
# events properly and we NEVER USE THIS EXPECTING IT TO BE A PROPER ACTIVERESOURCE
# then everything will be fine :)

  self.format = :xml
  self.site = "http://#{Settings.bksb_url}"
  self.user = Settings.bksb_iis_username
  self.password = Settings.bksb_iis_pwd

  def BKSB.element_path(id, prefix_options = {}, query_options = nil)
    "/bksb_reporting/API/Results.aspx#{query_string(:p => Settings.bksb_pwd, :u => id)}"
  end

  def self.import_for(person_code)
    person = Person.get(person_code)
    x = BKSB.find(person_code)
    x.Subject.each do |s|
      subject = s.subjectName
      s.Section.find{|x| x.sectionName == "Assessments"}.AssessmentType.each do |a|
        (atype,result,date) = if a.AssessmentType == "IA"
            next unless a.respond_to? :IA_Result
            ["Initial Assessment","Level #{a.IA_Result.result.last}",DateTime.parse(a.IA_Result.DateCompleted)]
          else
            next unless a.respond_to? :Diag_Result
            ["Diagnostic","#{a.Diag_Result.totalScore} out of #{a.Diag_Result.totalOutOf} (#{a.Diag_Result.percentScore}%)",DateTime.parse(a.Diag_Result.dateTaken)]
        end
        person.qualifications.find_or_create_by_title_and_grade_and_created_at("#{atype}: #{subject}",result,date)
      end
    end
    return person
  end

end
