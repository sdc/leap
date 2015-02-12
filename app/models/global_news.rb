class GlobalNews < ActiveRecord::Base
  attr_accessible :body, :title, :subtitle

  def to_tile
    Tile.new(title: subtitle ? title : "News",
             subtitle: subtitle || title,
             bg: "4f2170",
             icon: "fa-newspaper-o",
             modal_title: "#{title} #{subtitle ? "<small>#{subtitle}</small>" : nil}",
             modal_body: body,
             object: self)
  end

end
