module ApplicationHelper

  def icon_link(text,link="#",icon=false)
    link_to link, :remote => false, :class => "ajax_update_main_pane sidebar_button" do
      content_tag(:div, :class => "icon") do
        image_tag("icons/#{icon or text.downcase.tr(' ','_')}.png", :size => "30x30")
      end +
      content_tag(:div, text, :class => "label")
    end
  end

end
