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

class Admin::SettingsController < ApplicationController

  skip_before_filter :maintenance_mode
  before_filter :admin_only
  layout "admin"

  def index
    @settings = Settings.defaults.keys.sort
  end

  def create
    Settings.defaults.keys.each do |k|
      if params[k] 
        Settings[k] = params[k]
      end
    end
    redirect_to admin_settings_url
  end

end
