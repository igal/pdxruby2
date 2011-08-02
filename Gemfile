source 'http://rubygems.org'

# Load additional gems from "Gemfile.local" if it exists, has same format as this file.
begin
  data = File.read('Gemfile.local')
rescue Errno::ENOENT
  # Ignore
end
eval data if data

# Load database driver specified in "config/database.yml"
require 'erb'
require 'yaml'
filename = File.join(File.dirname(__FILE__), 'config', 'database.yml')
raise "Can't find database configuration at: #{filename}" unless File.exist?(filename)
databases = YAML.load(ERB.new(File.read(filename)).result)
railsenv = ENV['RAILS_ENV'] || 'development'
raise "Can't find database configuration for environment '#{railsenv}' in: #{filename}" unless databases[railsenv]
adapter = databases[railsenv]['adapter']
raise "Can't find database adapter for environment '#{railsenv}' in: #{filename}" unless databases[railsenv]['adapter']
adapter = 'pg' if adapter == 'postgresql'
gem adapter

gem 'rails', '2.3.12'

gem 'rdoc'
gem 'RedCloth', '4.2.3'
gem 'facets', '2.5.2', :require => false # Selectively loaded by "config/initializers/dependencies.rb"
gem 'vpim', '0.695', :require => 'vpim/icalendar'
gem 'formtastic', '1.0.1', :require => 'formtastic'
gem 'will_paginate', '2.3.15', :require => 'will_paginate'
gem 'authlogic', '2.1.6'
gem 'authlogic-oid', '1.0.4', :require => false
gem 'right_aws', '1.10.0', :require => false # we aren't actually using AWS, but paperclip demands the gem
gem 'paperclip', '2.3.8', :require => 'paperclip'
gem 'paper_trail', '1.6.4'
gem 'redirect_routing', '0.0.4'
gem 'recaptcha', '0.3.1', :require => 'recaptcha/rails'

group :development, :test do
  gem 'rspec', '~> 1.3.1'
  gem 'rspec-rails', '~> 1.3.3'
  gem 'rcov', '~> 0.9.9'
end
