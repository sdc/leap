class Intervention < Eventable
  attr_accessible :disc_text, :incident_date, :pi_type, :referral, :referral_category, :referral_text, :workshops

  after_create { |i| i.events.create!(event_date: created_at, transition: :create) }

  after_save do |i|
    if i.disc_text_changed? && i.disc_text_was.nil?
      i.events.create!(event_date: Time.now, transition: :complete, parent_id: i.events.creation.first.id)
    end
  end

  def self.intervention_types
    its = {}
    Settings.intervention_types.split(";").each { |x| b = x.split(':'); its[b.first.split(",").first] = b.last.split(",") }
    return its
  end

  def self.intervention_note(key)
    Hash[Settings.intervention_types.split(";").map { |x| x.split(':').first.split(',') }][key]
  end

  def icon_url(tr)
    case tr
    when :create   then "events/intervention_referral.png"
    when :complete then "events/disciplinaries.png"
    end
  end

  def title(tr)
    case tr
    when :create   then "Intervention Referral"
    when :complete then "Outcome"
    end
  end

  def extra_panes(tr)
    if tr == :complete
      { "Referral Details" => "events/tabs/pi_refer_details" }
    elsif disc_text.nil?
      { "Outcome" => "events/tabs/disciplinary_outcome" }
    end
  end

  def status
    disc_text ? :incomplete : :current
  end

  def body
    disc_text if status == :incomplete
  end
end
