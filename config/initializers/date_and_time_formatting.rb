# From: http://sazwqa.wordpress.com/2008/02/18/defining-customized-date-time-format-in-rails/
formats = {
  :usual => '%a %b %d, %Y at %I:%M%p',
  :brief => '%I:%M%p',
}
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(formats)
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(formats)
