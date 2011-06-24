class Disciplinary < ActiveRecord::Base

  has_many :events, :as => :eventable, :dependent => :destroy
  belongs_to :person

  validates :person_id, :presence => true

  after_create {|disciplinary| disciplinary.events.create!(:event_date => created_at)}

  # Returns the note eventable icon URL. This is always the same.
  def icon_url
    "events/disciplinary.png"
  end

  # Returns the note eventable  Title. This is always the same.
  def title
    case level
      when 1
        "Disciplinary Level One"
      when 2
        "Disciplinary Level Two"
      when 3
        "Disciplinary Level Three"
    end
  end

end
