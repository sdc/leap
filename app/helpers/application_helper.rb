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

require 'ipaddr'

module ApplicationHelper

  def icon_link(text,link="#",icon=false)
    content_tag(:li, :class => "row") do
      link_to link do
        image_tag("icons/#{icon or text.downcase.tr(' ','_')}.png", :size => "30x30") + text
      end
    end
  end

  def fa_link(text,link="#",icon=false)
    content_tag(:li, :class => "row") do
      link_to link do
        tag("i", :class => "fa fa-fw #{icon}") + text
      end
    end
  end

  def link_to_submit(*args, &block)
    link_to_function (block_given? ? capture(&block) : args[0]), "$(this).closest('form').submit()", args.extract_options!
  end

  def client_ip_address_is_internal
    client_ip = IPAddr.new(request.remote_ip).to_i

    ip_ranges = []
    Settings.network_ip_ranges.split("|").each{|x| b=x.split(';'); ip_ranges << { :internal => (b[0] == "1"), :from => b[1], :to => b[2], :note => b[3] } }

    ip_ranges.each do |range| if ( (IPAddr.new(range[:from]).to_i .. IPAddr.new(range[:to]).to_i).include? client_ip ) then return range[:internal] end end

    return false
  end

  def get_uri_mime_type(uri_str, limit = 10)
    return nil if limit == 0

    uri = URI.parse(uri_str) rescue nil

    return nil if uri.nil?

    http = Net::HTTP.new( uri.host, uri.port )
    http.open_timeout = 2
    http.read_timeout = 2
    http.use_ssl = (uri.scheme.casecmp("https") == 0)

    response = http.start() { |http| http.head(uri.request_uri) } rescue nil

    if response.kind_of? Net::HTTPSuccess
      response.header['Content-Type']
    elsif response.kind_of? Net::HTTPRedirection
      location = response['location']
      get_uri_mime_type(location, limit - 1)
    else
      nil
    end

  end

end
