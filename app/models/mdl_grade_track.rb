class MdlGradeTrack < Eventable
  attr_accessible :course_type, :mag, :mdl_id, :name, :tag, :total, :created_at

  belongs_to :person

  after_create {|t| t.events.create(:event_date => t.created_at, :transition => ':create')}

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
    Tile.new({:title        => name || "#{course_type.humanize} Tracker",
              :bg           => "aacccc",
              :icon         => "fa-bar-chart-o",
              :partial_path => "tiles/grade_track",
              :link         => name ? Settings.moodle_host + Settings.moodle_path + "/grade/report/#{Person.user.staff? ? 'grader' : 'user'}/index.php?id=" + mdl_id.to_s : nil,
              :object       => self})
  end

end
