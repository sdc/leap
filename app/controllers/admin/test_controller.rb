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

class Admin::TestController < ApplicationController
  skip_before_filter :set_user  , except: [:stats]
  before_filter      :admin_page, only: [:stats]

  def index
  end

  def login
    session[:user_id] = params[:login]
    session[:user_affiliation] = params[:affiliation]
    if person = Person.get(session[:user_id],true)
      redirect_to person
    else
      redirect_to :back, notice: "That person doesn't exist!"
    end
  end
end
