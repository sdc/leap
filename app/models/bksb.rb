class BKSB < ActiveResource::Base
  # Look, this happens in an odd way. I rewrite element_path so it points to all the
  # results for a person. You pass in the person code as the id. So, yes, Rails would
  # expect a single result but actually gets a load of results in the format BKSB
  # presents them. But as long as I parse these out and create the Qualification
  # events properly and we NEVER USE THIS EXPECTING IT TO BE A PROPER ACTIVERESOURCE
  # then everything will be fine :)

  unless Settings.bksb_url.blank?
    self.format = :xml
    self.site = "http://#{Settings.bksb_url}"
    self.user = Settings.bksb_iis_username
    self.password = Settings.bksb_iis_pwd
  end

  def self.element_path(id, prefix_options = {}, query_options = nil)
    "/bksb_reporting/API/Results.aspx#{query_string(p: Settings.bksb_pwd, u: id)}"
  end

  def self.import_for(person_code)
    person = Person.get(person_code)
    x = BKSB.find(person_code)
    x.Subject.each do |s|
      subject = s.subjectName
      s.Section.find { |x| x.sectionName == "Assessments" }.AssessmentType.each do |a|
        if a.AssessmentType == "IA"
          next unless a.respond_to? :IA_Result
          (a.IA_Result.kind_of?(Array) ? a.IA_Result : [a.IA_Result]).each do |a|
            begin
              n = person.qualifications.find_or_initialize_by_mis_id_and_awarding_body(a.session_id, "BKSB")
              n.title = "Initial Assessment: #{subject}"
              n.grade = "#{"Entry " if a.result.match(/Entry/)}Level #{a.result.last}"
              n.created_at = DateTime.parse(a.DateCompleted)
              n.save
            rescue
              # Just in case something breaky happens
            end
          end
        else
          next unless a.respond_to? :Diag_Result
          (a.Diag_Result.kind_of?(Array) ? a.Diag_Result : [a.Diag_Result]).each do |a|
            begin
              n = person.qualifications.find_or_initialize_by_mis_id_and_awarding_body(a.session_id, "BKSB")
              n.title = "Diagnostic Assessment: #{subject}"
              n.grade = "#{a.totalScore} out of #{a.totalOutOf} (#{a.percentScore}%)"
              n.created_at = DateTime.parse(a.dateTaken)
              n.save
              logger.error "Error importing BKSB for #{person_code}. #{$!}"
            rescue
              # Just in case something breaky happens
            end
          end
        end
      end
    end
    person
  end
end
