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

module ApplicationHelper

  def icon_link(text,link="#",icon=false)
    link_to link, :remote => false, :class => "sidebar_button" do
      content_tag(:div, :class => "icon") do
        image_tag("icons/#{icon or text.downcase.tr(' ','_')}.png", :size => "30x30")
      end +
      content_tag(:div, text, :class => "label")
    end
  end

end
