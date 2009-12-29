module DisplayTextileForHelper
  def display_textile_for(text)
    return auto_link(textilize(sanitize(text)), :all, :rel => 'nofollow')
  end

  def display_textile_help_link(title="Formatting")
    return link_to(title, 'http://elzr.com/static/textile', :popup => true)
  end
end
