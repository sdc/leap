class Note < ActiveRecord::Base

  has_many :events, :as => :eventable

  after_create {|note| note.events.create(:event_date => created_at)}

end
