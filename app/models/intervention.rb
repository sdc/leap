class Intervention < Eventable

  attr_protected
  include ActiveModel::ForbiddenAttributesProtection  

  scope :this_year, lambda {where("interventions.updated_at > ?", MISC::MiscDates.start_of_acyr )}

  # attr_accessible :disc_text, :incident_date, :pi_type, :referral, :referral_category, :referral_text, :workshops

  after_create {|i| i.events.create!(:event_date => created_at, :transition => :create)}

  after_save do |i|
    if i.disc_text_changed? and i.disc_text_was.nil?
      i.events.create!(:event_date => Time.now, :transition => :complete, :parent_id => i.events.creation.first.id)
    end
  end

  def self.intervention_types
    its = {}
    Settings.intervention_types.split(";").each{|x| b=x.split(':'); its[b.first.split(",").first] = b[1].split(",")}
    return its
  end

  def self.intervention_note(key)
    Hash[Settings.intervention_types.split(";").map{|x| x.split(':').first.split(',')}][key]
  end

  def icon_url(tr)
    case tr
    when :create   then "events/intervention_referral.png"
    when :complete then "events/disciplinaries.png"
    end
  end

  def icon_class(tr)
    case tr
    when :create then "fa-flag"
    when :complete then "fa-exclamation-circle"
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
      {"Referral Details" => "events/tabs/pi_refer_details"}
    elsif disc_text.nil?
      {"Outcome" => "events/tabs/disciplinary_outcome"}
    end
  end

  def status
    disc_text ? :incomplete : :current
  end

  def body
    disc_text if status == :incomplete
  end

  private

  def self.intervention_group_types(group)
    its = []
    Settings.intervention_groups.split("|").each{|x| b=x.split(':'); its = b[2].tr(" ","_").split(";") if b[0] == group}
    return its
  end

  def self.intervention_group_title(group)
    its = []
    Settings.intervention_groups.split("|").each{|x| b=x.split(':'); its = b[1] if b[0] == group}
    return its
  end

  def self.intervention_groups
    its = {}
    Settings.intervention_groups.split("|").each{|x| b=x.split(':'); b[2].split(";").each{|t| its[t] = b[0] } }
    return its
  end

end
