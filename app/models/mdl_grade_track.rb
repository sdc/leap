class MdlGradeTrack < ActiveRecord::Base
  attr_accessible :course_type, :mag, :mdl_id, :name, :tag, :total

  def self.import_for(person)
    person = person.kind_of?(Person) ? person : Person.get(person) 
    tracks = ActiveResource::Connection.new(Settings.moodle_host).
                 get("#{Settings.moodle_path}/webservice/rest/server.php?" +
                 "wstoken=#{Settings.moodle_token}&wsfunction=local_leapwebservices_get_targets_by_username&username=" +
                 person.username + Settings.moodle_user_postfix).body
    tracks = Nokogiri::XML(tracks).xpath('//MULTIPLE/SINGLE').each do |course|
      coursetype = course.xpath("KEY[@name='leapcore']/VALUE").first.content
      next unless ["test","maths","english","core"].include? coursetype
      person.mdl_grade_tracks.create do |t|
        t.name   = course.xpath("KEY[@name='course_fullname']/VALUE").first.content
        t.mdl_id = course.xpath("KEY[@name='course_id']/VALUE").first.content
        t.tag    = course.xpath("KEY[@name='tag_display']/VALUE").first.content
        t.mag    = course.xpath("KEY[@name='mag_display']/VALUE").first.content
        t.total  = course.xpath("KEY[@name='course_total_display']/VALUE").first.content
        t.course_type = coursetype
      end
    end
  end

  def to_tile
    Tile.new({:title        => name || "#{course_type.humanize} Tracker",
              :bg           => "aacccc",
              :icon         => "fa-bar-chart-o",
              :partial_path => "tiles/grade_track",
              :link         => name ? Settings.moodle_host + Settings.moodle_path + "/grade/report/user/index.php?id=" + mdl_id.to_s : nil,
              :object       => self})
  end

end
