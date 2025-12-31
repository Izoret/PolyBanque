module ApplicationHelper
  def page_header(title, subtitle = nil)
    content_for :page_header, title
    content_for :page_subtitle, subtitle
  end

  def page_footer(route)
    content_for :page_footer, route
  end
end
