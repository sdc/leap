class LearningAction < Eventable
  after_create { |la| la.events.create!(event_date: created_at, transition: :create) }
  belongs_to :person

  def font_icon
    "fa-road"
  end

  def timeline_template
    "learning_action"
  end

  def title
    "Learning Log: " + unit
  end

  def timeline_attrs(tr)
    [:target_outcome, :unit, :body, :outcome, :reflection]
  end

  def event_tabs
    { "Outcome" => "lap_outcome" }
  end

end
