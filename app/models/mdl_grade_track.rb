class MdlGradeTrack < Eventable
  attr_accessible :course_type, :mag, :mdl_id, :name, :tag, :total, :created_at, :created_by_id

  belongs_to :person

  after_create {|t| t.events.create(:event_date => t.created_at, :transition => ':create')}

  scope "english", -> { where(:course_type => ["english","gcse_english"]) }
  scope "maths", -> { where(:course_type => ["maths","gcse_maths"]) }
  scope "core", ->{ where("course_type NOT IN (?)",["maths","gcse_maths","english","gcse_english"]) }

  def self.import_all 
    if Settings.moodle_grade_track_import == "on"
      puts "\n\n****************************************"
      puts "* Stating Moodle Grade Tracker Imports *"
      puts "****************************************\n"
      peeps = ActiveResource::Connection.new(Settings.moodle_host).
                get("#{Settings.moodle_path}/webservice/rest/server.php?" +
                "wstoken=#{Settings.moodle_token}&wsfunction=local_leapwebservices_get_users_with_mag").body
      Nokogiri::XML(peeps).xpath('//MULTIPLE/SINGLE').each do |peep|
        import_for(peep.xpath("KEY[@name='username']/VALUE").first.content)
      end
    else 
      puts "Grade Track Import turned off."
    end
  end

  def self.import_for(person)
    person = person.kind_of?(Person) ? person : Person.get(person) 
    begin
      tracks = ActiveResource::Connection.new(Settings.moodle_host).
                   get("#{Settings.moodle_path}/webservice/rest/server.php?" +
                   "wstoken=#{Settings.moodle_token}&wsfunction=local_leapwebservices_get_targets_by_username&username=" +
                   person.username + Settings.moodle_user_postfix).body
    rescue
      # Almost certainly the user doesn't exist on Moodle yet
      return nil
    end
    tracks = Nokogiri::XML(tracks).xpath('//MULTIPLE/SINGLE').each do |course|
      next if course.xpath("KEY[@name='l3va']/VALUE").first.content.blank?
      next if person.mdl_grade_tracks.where(:created_at  => Time.at(course.xpath("KEY[@name='course_total_modified']/VALUE").first.content.to_i),
                                            :course_type => course.xpath("KEY[@name='leapcore']/VALUE").first.content).any?
      person.mdl_grade_tracks.create do |t|
        t.name        = course.xpath("KEY[@name='course_fullname']/VALUE").first.content
        t.mdl_id      = course.xpath("KEY[@name='course_id']/VALUE").first.content
        t.tag         = course.xpath("KEY[@name='tag_display']/VALUE").first.content
        t.mag         = course.xpath("KEY[@name='mag_display']/VALUE").first.content
        t.total       = course.xpath("KEY[@name='course_total_display']/VALUE").first.content
        t.created_at  = Time.at(course.xpath("KEY[@name='course_total_modified']/VALUE").first.content.to_i)
        t.course_type = course.xpath("KEY[@name='leapcore']/VALUE").first.content
      end
    end
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
              :link         => Settings.moodle_host + Settings.moodle_path + "/grade/report/user/index.php?id=" + mdl_id.to_s,
              :object       => self})
  end

  def status
    begin
      unless tag.blank?
        return :sucess if Grade.new(total) >= Grade.new(tag)
      end
      unless mag.blank?
        return :current if Grade.new(total) >= Grade.new(mag)
      end
    rescue ArgumentError
      return :danger
    end
    return :danger
  end

end
