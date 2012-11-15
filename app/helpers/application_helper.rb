module ApplicationHelper
  def state_nav_li(text, path, icon, active)
    icon_class = active ? "icon-#{icon} icon-white" : "icon-#{icon}"
    li_class = active ? "active" : ""
    i = content_tag('i', '', class: icon_class)
    link = link_to(path) do
      concat(i)
      concat(" ")
      concat(text)
    end
    content_tag('li', link, class: li_class)
  end
end
