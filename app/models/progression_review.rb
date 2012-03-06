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

  before_create {|pr| pr.reason = nil if approved }
  after_create  {|pr| pr.events.create!(:event_date => created_at, :transition => pr.approved ? :complete : :overdue)}

  def subtitle; approved ? "Approved" : "Not approved" end

  def status; approved ? :complete : :incomplete end

  def title; "Continuing Learning" end

end
