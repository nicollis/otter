module ApplicationHelper
  def full_title(page_title = '')
    base = "Otter"
    page_title.empty? ? base : page_title + " | " + base
  end
end
