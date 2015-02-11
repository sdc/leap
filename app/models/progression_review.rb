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

class ProgressionReview < Eventable
  attr_accessible :approved, :reason

  serialize :reason

  validates :reason, presence: true, unless: :approved?

  before_create {|pr| pr.reason = nil if approved; reason.delete("") if reason}
  
  after_create  do |pr| 
    ev = pr.events.create! event_date: created_at, transition: :complete
    unless pr.approved?
      pr.person.targets.create! event_id: ev.id, body: "Speak to a member of Helpzone about alternative courses", target_date: Date.parse("31-05-2013")
    end
  end

  def subtitle; approved ? "Approved" : "Not approved" end

  def status; approved ? :complete : :incomplete end

  def title; "Continuing Learning" end
 
  def tile_icon
    "#{approved ? 'fa-ban' : 'fa-check'} on fa-fast-forward"
  end
end
