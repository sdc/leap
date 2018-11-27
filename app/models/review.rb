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

class Review < Eventable

  has_many :review_lines, :dependent => :destroy

  # after_create {|req| req.events.create!(:event_date => created_at - 10, :transition => :create)}

  def strong_params_validate
    [{:event_date => self.created_at - 10, :transition => :create}]
  end  

  before_save do |rev|
    #rev.attendance = person.attendance.att_year
    if rev.published_changed? and !rev.published_was
      events.create(:event_date => Time.now, :transition => :complete) if rev.published
    end
  end
  
  def title
    window
  end

  def extra_panes
    [["Comment","reviews/edit"]] if Person.user.staff? and status.to_s == "current"
  end

  def status; published ? :complete : :current end

  def staff_only?
    !published
  end

  def tile_icon
    "fa-file-text"
  end

  def accessible_attributes
    return ['attendance', 'published', 'body', 'window']
  end     

end
