# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.10' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  config.autoload_paths += [
    "#{RAILS_ROOT}", 
    "#{RAILS_ROOT}/app/observers",
    "#{RAILS_ROOT}/app/mixins",
  ]

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  require 'fileutils'

  # For all environments
  config.gem 'RedCloth', :version => '4.2.3'
  config.gem 'facets', :version => '2.5.2', :lib => false # Selectively loaded by config/initializers/dependencies.rb
  config.gem 'vpim', :version => '0.695', :lib => 'vpim/icalendar'
  config.gem 'formtastic', :version => '1.0.1', :lib => 'formtastic'
  config.gem 'will_paginate', :version => '2.3.15', :lib => 'will_paginate'
  config.gem 'authlogic', :version => '2.1.6'
  config.gem 'authlogic-oid', :version => '1.0.4', :lib => false
  config.gem 'right_aws', :version => '1.10.0', :lib => false # we aren't actually using AWS, but paperclip can, so it requires it.
  config.gem 'paperclip', :version => '2.3.8', :lib => 'paperclip'
  config.gem 'paper_trail', :version => '1.6.4'
  config.gem 'redirect_routing', :version => '0.0.4'

  # For special environments
  if %w[test development].include? RAILS_ENV
    config.gem 'rspec', :version => '1.3.1', :lib => false
    config.gem 'rspec-rails', :version => '1.3.3', :lib => false
    config.gem 'rcov', :version => '0.9.9', :lib => false
  end

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  config.active_record.observers = :cacher

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  ## config.time_zone = 'UTC'
  config.time_zone = 'Pacific Time (US & Canada)'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  # Configure caching: http://guides.rubyonrails.org/caching_with_rails.html
  cache_dir = "#{RAILS_ROOT}/tmp/cache/#{RAILS_ENV}"
  FileUtils.mkdir_p(cache_dir)
  config.cache_store = :file_store, cache_dir
end
