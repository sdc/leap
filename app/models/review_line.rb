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
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

class ReviewLine < Eventable

  belongs_to :review

  serialize :teachers

  after_create :notify_teachers

  def notify_teachers
    teachers.each do |t|
      events.create!(:person_id => t,:event_date => created_at, :transition => :hidden, :parent_id => review.events.hidden.first.id, :about_person_id => person_id)
    end
  end

  def icon_url
    "events/reviews.png"
  end

  def extra_panes
    [["Edit","review_lines/edit"]]
  end

  def body
    comments
  end

  def title
    self[:title]
  end

end
