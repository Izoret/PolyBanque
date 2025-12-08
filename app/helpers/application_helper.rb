module ApplicationHelper
  def page_header(title)
    content_for :page_header, title
  end
end
