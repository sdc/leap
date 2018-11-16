class MdlBadge < Eventable

  attr_protected
  include ActiveModel::ForbiddenAttributesProtection
  
  # attr_accessible :body, :image_url, :mdl_course_id, :person_id, :title, :created_at
  after_create {|badge| badge.events.create!(:event_date => created_at, :transition => :create)}
  belongs_to :person

  def self.import_all
    if Settings.moodle_badge_import == "on"
      puts "\n*****************************************************"
      puts "* " + Time.zone.now.strftime("%Y-%m-%d %T") + " Starting Moodle Badge Imports *"
      puts "*****************************************************\n"
      peeps = ActiveResource::Connection.new(Settings.moodle_host).
                get("#{Settings.moodle_path}/webservice/rest/server.php?" +
                "wstoken=#{Settings.moodle_token}&wsfunction=local_leapwebservices_get_users_with_badges").body

      Nokogiri::XML(peeps).xpath('//MULTIPLE/SINGLE').each do |peep|
        begin
          import_for(peep.xpath("KEY[@name='username']/VALUE").first.content)
        rescue
          puts Time.zone.now.strftime("%Y-%m-%d %T") + " Badge content not found. "
        end
      end
      puts "\n*****************************************************"
      puts "* " + Time.zone.now.strftime("%Y-%m-%d %T") + " Finished Moodle Badge Imports *"
      puts "*****************************************************\n"
    else
      puts Time.zone.now.strftime("%Y-%m-%d %T") + " Grade Track Import turned off."
    end
  end

  def MdlBadge.import_for(person)
    person = person.kind_of?(Person) ? person : Person.get(person)
    if person.kind_of?(Person)

      [person.username, person.mis_id].uniq.reject{ |c| c.nil? || c.empty? }.each do |passid|
        begin
          badges = ActiveResource::Connection.new(Settings.moodle_host).
                       get("#{Settings.moodle_path}/webservice/rest/server.php?" +
                       "wstoken=#{Settings.moodle_token}&wsfunction=local_leapwebservices_get_badges_by_username&username=" +
                       passid + Settings.moodle_user_postfix).body
        rescue
          # Almost certainly the user doesn't exist on Moodle yet
          # puts Time.zone.now.strftime("%Y-%m-%d %T") + " [#{person.mis_id}] #{person.forename} #{person.surname} (#{passid}) - Badge person not in Moodle?"
          return nil
        end

        badges = Nokogiri::XML(badges).xpath('//MULTIPLE/SINGLE').each do |badge|
          image_url = badge.xpath("KEY[@name='image_url']/VALUE").first.try(:content)
          next if person.mdl_badges.where(:image_url => image_url).any?

          begin
            person.mdl_badges.create do |t|
              t.title       = badge.xpath("KEY[@name='name']/VALUE").first.try(:content)
              t.created_at  = Time.at(badge.xpath("KEY[@name='date_issued']/VALUE").first.try(:content).to_i)
              t.body        = badge.xpath("KEY[@name='description']/VALUE").first.try(:content)
              t.image_url   = image_url
              t.link_url    = badge.xpath("KEY[@name='details_link']/VALUE").first.try(:content)
              t.mdl_course_id=badge.xpath("KEY[@name='course_id']/VALUE").first.try(:content)
            end
            puts Time.zone.now.strftime("%Y-%m-%d %T") + " [#{person.mis_id}] #{person.forename} #{person.surname} (#{passid})" + " - Badge: " + badge.xpath("KEY[@name='name']/VALUE").first.try(:content)
          rescue
            puts Time.zone.now.strftime("%Y-%m-%d %T") + " [#{person.mis_id}] #{person.forename} #{person.surname} (#{passid}) - Badge import error."
          end
        end
      end

    end
  end

  def icon_url 
    image_url 
  end

  def to_course_tile
    Tile.new({:title => "PPD",
              :bg => "7755cc",
              :icon => "fa-dot-circle-o",
              :partial_path => "tiles/course_badges",
              :object => self})
  end

  def all_in_course
    person.mdl_badges.where(:mdl_course_id => mdl_course_id)
  end

  def title
    "Badge"
  end

  def tile_attrs
    {:icon => "fa-dot-circle-o",
     :title => "New Badge",
     :subtitle => self[:title],
     :partial_path => "tiles/mdl_badge",
     :link => link_url,
     :object => self}
  end

 
end
