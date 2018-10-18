# Leap - Electronic Individual Learning Plan Software
# Copyright (C) 2014 South Devon College

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

class Admin::DataController < ApplicationController

  respond_to :html, :json, :xml
  before_filter :superuser_page
  layout :cloud

  def sync_grade_tracks
    MdlGradeTrack.import_for(params[:person_id])
    redirect_to :back
  end

end
