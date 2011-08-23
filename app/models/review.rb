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

class Review < Eventable

  belongs_to :review_window
  belongs_to :person
  has_many   :review_lines, :dependent => :destroy

  delegate :start_date, :to => :review_window
  delegate :end_date,   :to => :review_window

  after_create {|review| review.events.create!(:event_date => created_at, :transition => :hidden)}
  after_create :create_review_lines

  def title
    review_window.name
  end

  def create_review_lines
    a = person.timetable_events(:from => start_date, :to => end_date)
    a.each do |l|
      next if review_lines.detect{|la| la.mis_id == l.id}
      review_lines.create(:person_id => person.id, :mis_id => l.mis_id, :title => l.title, :teachers => l.teachers.map{|t| t.id})
    end
  end

end
