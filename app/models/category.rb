class Category < ActiveRecord::Base

  default_scope { where(deleted: false) }

  def styles
    {fg:          {color: color},
     bg:          {background: color, color: "#eee"},
     bgHighlight: {background: highlight},
     border:      {"border-color" => color},
     borderHl:    {"border-color" => highlight}
    }
  end

  def highlight
    Color::RGB.from_html(color).adjust_brightness(25).html
  end

end
