module ApplicationHelper
  def page_header(title)
    content_for :page_header, title
  end

  def page_footer(route)
    content_for :page_footer, route
  end
end
