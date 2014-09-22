# Leap - Electronic Individual Learning Plan Software
# Copyright (C) 2011 South Devon College

# Leap is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Leap is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with Leap.  If not, see <http://www.gnu.org/licenses/>.

class Eventable < ActiveRecord::Base

  self.abstract_class = true

  belongs_to :person
  belongs_to :created_by, :foreign_key => "created_by_id", :class_name => "Person"
  has_many :events, :as => :eventable, :dependent => :destroy

  before_validation do |e| 
    update_attribute("created_by_id", Person.user ? Person.user.id : nil) unless e.created_by_id
  end

  validates :person_id, :presence => true

  def icon_url
    "events/#{self.class.name.tableize}.png"
  end
  
  def humanize
    self.class.name.underscore.humanize.titleize
  end

  def title
    humanize
  end

  def staff_only?
    false
  end

  def status
    return :unknown
  end
  
  def created_by_text
    if respond_to? :mis and mis
      "Imported from MIS"
    elsif created_by
      "#{self.humanize} created by #{created_by.name}"
    else
      "Auto-generated"
    end
  end

  def timetable_length
    3600
  end


  # For new front page

  def tile_bg
    (1..6).map{((6..9).to_a.sample).to_s}.join
    #(rand * 999999).floor.to_s.ljust(6,"0")
  end

  def tile_icon
    "fa-circle-thin"
  end

 def to_tile
   events.last.to_tile
 end

end
