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

class SupportStrategy < Eventable

  attr_protected
  include ActiveModel::ForbiddenAttributesProtection   

  # after_create {|req| req.events.create!(:event_date => created_at, :transition => :create, :parent_id => event_id)}

  def strong_params_validate
    [{:event_date => self.created_at, :transition => :create, :parent_id => self.event_id}]
  end  

  after_save do |ss|
    if ss.agreed_date_changed? and ss.agreed_date_was == nil
      ss.events.create(:event_date => ss.agreed_date, :transition => :start)
    end
    if ss.declined_date_changed? and ss.declined_date_was == nil
      ss.events.create(:event_date => ss.declined_date, :transition => :incomplete)
    end
    if ss.completed_date_changed? and ss.completed_date_was == nil
      ss.events.create(:event_date => ss.completed_date, :transition => :complete)
    end
  end


  def extra_panes
    [["Details","events/tabs/support_strategy_details"]]
  end

  def status
    return "incomplete" if declined_date
    return "complete"   if completed_date
    return "current"    if agreed_date
    return "not_started"
  end

  def title(tr)
    case tr
    when :complete then "Support Strategy Complete"
    when :incomplete then "Support Strategy Declined"
    when :start then "Support Strategy Agreed"
    when :create then "Support Strategy Created"
    end
  end

end
