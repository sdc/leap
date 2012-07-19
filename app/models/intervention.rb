class Intervention < Eventable

  after_create {|i| i.events.create!(:event_date => created_at, :transition => :create)}

  def self.intervention_types
    its = {}
    Settings.intervention_types.split(";").each{|x| b=x.split(':'); its[b.first] = b.last.split(",")}
    return its
  end

  def icon_url(tr)
    case tr
    when :create then "events/intervention_referral.png"
    end
  end

  def title(tr)
    case tr
    when :create then "Intervention Referral"
    end
  end

end
