class PersonCourse < ActiveRecord::Base

  belongs_to :person, :dependent => :destroy
  belongs_to :course, :dependent => :destroy
  has_many :events, :as => :eventable, :dependent => :destroy

end
