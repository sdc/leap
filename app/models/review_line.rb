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
  belongs_to :person

  after_create do |line|
    line.review = Review.find_or_create_by_person_id_and_window(person_id, window)
    line.save
    line.events.create!(:event_date => created_at, :transition => :create, :parent_id => review.events.creation.first.id)
  end

  def icon_url
    "events/reviews.png"
  end

  def title
    window
  end

  def extra_panes
    Person.user.staff? ? [["edit","review_lines/edit"]] : nil
  end

  def status
    review ? review.status : :complete
  end

end
