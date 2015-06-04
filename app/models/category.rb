class Category < ActiveRecord::Base

  default_scope { where(deleted: false) }

  def styles
    {fg:     {color: color},
     bg:     {background: color, color: "#eee"},
     border: {"border-color" => color}
    }
  end

end
