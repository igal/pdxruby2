# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def required_field
    return content_tag(:span, '(Required)', :class => [:required_field])
  end
end
