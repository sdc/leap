class MdlBadge < Eventable
  after_create { |badge| badge.events.create!(event_date: created_at, transition: :create) }
  belongs_to :person

  def self.import_all
    if Settings.moodle_badge_import == "on"
      puts "\n\n****************************************"
      puts "* Stating Moodle Badge Imports *"
      puts "****************************************\n"
      peeps = ActiveResource::Connection.new(Settings.moodle_host)
              .get("#{Settings.moodle_path}/webservice/rest/server.php?" \
                "wstoken=#{Settings.moodle_token}&wsfunction=local_leapwebservices_get_users_with_badges").body
      Nokogiri::XML(peeps).xpath('//MULTIPLE/SINGLE').each do |peep|
        import_for(peep.xpath("KEY[@name='username']/VALUE").first.content)
      end
    else
      puts "Badge Import turned off."
    end
  end

  def self.import_for(person)
    person = person.kind_of?(Person) ? person : Person.get(person)
    begin
      badges = ActiveResource::Connection.new(Settings.moodle_host)
               .get("#{Settings.moodle_path}/webservice/rest/server.php?" \
                   "wstoken=#{Settings.moodle_token}&wsfunction=local_leapwebservices_get_badges_by_username&username=" +
                   person.username + Settings.moodle_user_postfix).body
    rescue
      # Almost certainly the user doesn't exist on Moodle yet
      return nil
    end
    Nokogiri::XML(badges).xpath('//MULTIPLE/SINGLE').each do |badge|
      image_url = badge.xpath("KEY[@name='image_url']/VALUE").first.content
      next if person.mdl_badges.where(image_url: image_url).any?
      person.mdl_badges.create do |t|
        t.title       = badge.xpath("KEY[@name='name']/VALUE").first.content
        t.created_at  = Time.at(badge.xpath("KEY[@name='date_issued']/VALUE").first.content.to_i)
        t.body        = badge.xpath("KEY[@name='description']/VALUE").first.content
        t.image_url   = image_url
        t.link_url    = badge.xpath("KEY[@name='details_link']/VALUE").first.content
        t.mdl_course_id = badge.xpath("KEY[@name='course_id']/VALUE").first.content
      end
    end
  end

  def icon
    image_url
  end

  def tile_wrap
    true
  end

  def tile_template 
    "badge"
  end

  def brick_template
    "badge"
  end

  def font_icon
    "fa-dot-circle-o"
  end

  def all_in_course
    person.mdl_badges.where(mdl_course_id: mdl_course_id)
  end

  def timeline_attrs
    { imageUrl: image_url,
      linkUrl: link_url}
  end
end
