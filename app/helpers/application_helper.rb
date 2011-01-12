module ApplicationHelper

  def icon_link(text,link="#",icon=false)
      content_tag(:div, :class => "icon_button") do 
        content_tag(:div, :class => "icon") do
          link_to link do
            image_tag("icons/#{icon or text.downcase}.png", :size => "30x30")
          end
        end +
        content_tag(:div, :class => "label")  do
          link_to text, link
        end
      end
  end

end
