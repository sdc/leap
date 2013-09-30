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

class ReviewLine < Eventable

  attr_accessible :body, :quality, :attitude, :punctuality, :completion, :window, :unit, :review_id

  belongs_to :review

  after_create do |line|
    line.review = Review.find_or_create_by_person_id_and_window(person_id, window) unless window.blank?
    line.save
    line.events.create!(:event_date => created_at, :transition => window.blank? ? :start : :create, :parent_id => review && review.events.creation.first.id)
  end

  def title
    window or "Individual Review"
  end

  def extra_panes
    [["Edit","events/tabs/review_line"]] if Person.user.staff? and status.to_s == "current"
  end

  def status
    review ? review.status : :complete
  end

  def staff_only?
    return true unless window
    review ? review.staff_only? : true
  end

end
