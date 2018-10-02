class MdlGradeTrack < Eventable
  attr_accessible :course_type, :mag, :mdl_id, :name, :tag, :total, 
                  :completion_total, :completion_out_of, :created_at, :created_by_id

  belongs_to :person

  after_create {|t| t.events.create(:event_date => t.created_at, :transition => ':create')}

  scope "english", -> { where(:course_type => ["english","gcse_english"]) }
  scope "maths", -> { where(:course_type => ["maths","gcse_maths"]) }
  scope "core", -> { where("course_type NOT IN (?)",["maths","gcse_maths","english","gcse_english"]) }

  def self.user_url(username)
    "#{Settings.moodle_host}#{Settings.moodle_path}/webservice/rest/server.php?" +
    "wstoken=#{Settings.moodle_token}&wsfunction=local_leapwebservices_get_targets_by_username&username=" +
    username + Settings.moodle_user_postfix
  end


  def self.import_all 
    if Settings.moodle_grade_track_import == "on"
      puts "\n\n*************************************************************"
      puts "* " + Time.zone.now.strftime("%Y-%m-%d %T") + " Starting Moodle Grade Tracker Imports *"
      puts "*************************************************************\n"
      peeps = ActiveResource::Connection.new(Settings.moodle_host).
                get("#{Settings.moodle_path}/webservice/rest/server.php?" +
                "wstoken=#{Settings.moodle_token}&wsfunction=local_leapwebservices_get_users_with_mag").body
      Nokogiri::XML(peeps).xpath('//MULTIPLE/SINGLE').each do |peep|
        begin
          import_for(peep.xpath("KEY[@name='username']/VALUE").first.content)
        rescue
          puts Time.zone.now.strftime("%Y-%m-%d %T") + " Grade content not found. "
        end
      end
      puts "\n\n*************************************************************"
      puts "* " + Time.zone.now.strftime("%Y-%m-%d %T") + " Finished Moodle Grade Tracker Imports *"
      puts "*************************************************************\n"
    else 
      puts Time.zone.now.strftime("%Y-%m-%d %T") + " Grade Track Import turned off."
    end
  end

  def self.import_for(person,delete = true)
    person = ( person.kind_of?(Person) ? person : Person.get(person.person_code) )
    if person.kind_of?(Person)
      # person.try(:mdl_grade_tracks).destroy_all if person.try(:mdl_grade_tracks).count > 0 && person.try(:mdl_grade_tracks).respond_to?(:destroy_all)
      begin
        tracks = ActiveResource::Connection.new(Settings.moodle_host).
                     get("#{Settings.moodle_path}/webservice/rest/server.php?" +
                     "wstoken=#{Settings.moodle_token}&wsfunction=local_leapwebservices_get_targets_by_username&username=" +
                     person.username + Settings.moodle_user_postfix).body
      rescue
        # Almost certainly the user doesn't exist on Moodle yet
        return nil
      end
      Nokogiri::XML(tracks).xpath('//MULTIPLE/SINGLE').each do |course|
      next if person.mdl_grade_tracks.where("
                created_at = ? and
                ifnull(course_type,'') = ? and
                ifnull(name,'') = ? and
                ifnull(mdl_id,'') = ? and
                ifnull(tag,'') = ? and
                ifnull(mag,'') = ? and
                ifnull(total,'') = ? and
                ifnull(completion_total,'') = ? and
                ifnull(completion_out_of,'') = ?
                ",
                Time.at(course.xpath("KEY[@name='course_total_modified']/VALUE").first.try(:content).to_i),
                course.xpath("KEY[@name='leapcore']/VALUE").first.try(:content).to_s,
                course.xpath("KEY[@name='course_fullname']/VALUE").first.try(:content).to_s,
                course.xpath("KEY[@name='course_id']/VALUE").first.try(:content).to_s,
                course.xpath("KEY[@name='tag_display']/VALUE").first.try(:content).to_s,
                course.xpath("KEY[@name='mag_display']/VALUE").first.try(:content).to_s,
                course.xpath("KEY[@name='course_total_display']/VALUE").first.try(:content).to_s,
                course.xpath("KEY[@name='course_completion_completed']/VALUE").first.try(:content).to_s,
                course.xpath("KEY[@name='course_completion_total']/VALUE").first.try(:content).to_s
               ).any?
        begin
          a=person.mdl_grade_tracks.create do |t|
            t.name              = course.xpath("KEY[@name='course_fullname']/VALUE").first.try(:content)
            t.mdl_id            = course.xpath("KEY[@name='course_id']/VALUE").first.try(:content)
            t.tag               = course.xpath("KEY[@name='tag_display']/VALUE").first.try(:content)
            t.mag               = course.xpath("KEY[@name='mag_display']/VALUE").first.try(:content)
            t.total             = course.xpath("KEY[@name='course_total_display']/VALUE").first.try(:content)
            t.completion_total  = course.xpath("KEY[@name='course_completion_completed']/VALUE").first.try(:content)
            t.completion_out_of = course.xpath("KEY[@name='course_completion_total']/VALUE").first.try(:content)
            t.course_type       = course.xpath("KEY[@name='leapcore']/VALUE").first.try(:content)
            t.created_at        = Time.at(course.xpath("KEY[@name='course_total_modified']/VALUE").first.try(:content).to_i)
          end
          puts Time.zone.now.strftime("%Y-%m-%d %T") + " " + a.attributes.inspect
        rescue
        end
      end

      person.mdl_grade_tracks.each do |mgt|
        begin
          if Nokogiri::XML(tracks).xpath('//MULTIPLE/SINGLE').select{|n| \
                  n.xpath("KEY[@name='leapcore']/VALUE").first.try(:content) == mgt.course_type \
              and Time.at(n.xpath("KEY[@name='course_total_modified']/VALUE").first.try(:content).to_i) == mgt.created_at \
              and n.xpath("KEY[@name='course_fullname']/VALUE").first.try(:content) == mgt.name \
              and n.xpath("KEY[@name='course_id']/VALUE").first.try(:content) == mgt.mdl_id.to_s \
              and n.xpath("KEY[@name='tag_display']/VALUE").first.try(:content) == mgt.tag \
              and n.xpath("KEY[@name='mag_display']/VALUE").first.try(:content) == mgt.mag \
              and n.xpath("KEY[@name='course_total_display']/VALUE").first.try(:content) == mgt.total \
              and n.xpath("KEY[@name='course_completion_completed']/VALUE").first.try(:content) == mgt.completion_total.to_s \
              and n.xpath("KEY[@name='course_completion_total']/VALUE").first.try(:content) == mgt.completion_out_of.to_s \
              }.none?
            puts Time.zone.now.strftime("%Y-%m-%d %T") + " Removing " + mgt.inspect
            mgt.destroy
          end
        rescue
        end
      end

    end
  end

  def completion_percent
    return nil unless completion_total and completion_out_of
    ((completion_total.to_f / completion_out_of) * 100).round
  end

  def to_tile
    bg = if(status == :success)
      "a66"
    elsif status == :current
      "da6"
    else
      "6a6"
    end
    Tile.new({:title        => name,
              :bg           => bg,
              :icon         => "fa-bar-chart-o",
              :partial_path => "tiles/grade_track",
              #:link         => Settings.moodle_host + Settings.moodle_path + "/grade/report/grader/index.php?id=" + mdl_id.to_s,
              #:link         => "javascript: $('.dont-edit-grades').toggle();$('.edit-grades').toggle()",
              :object       => self})
  end

  def status
    gtot = Grade.new(total)
    return :info if gtot.blank?
    gtag = Grade.new(tag)
    gmag = Grade.new(mag)
    begin
      unless gtag.blank?
        return :sucess if gtot >= gtag
      end
      unless gmag.blank?
        return :current if gtot >= gmag
      end
    rescue ArgumentError
      return :danger
    end
    return :danger
  end

end
