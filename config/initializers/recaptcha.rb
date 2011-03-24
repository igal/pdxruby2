raise "Invalid 'recaptcha' settings in 'config/settings.yml', please see 'config/settings.yml.sample' for example." unless SETTINGS.recaptcha and SETTINGS.recaptcha['public_key'] and SETTINGS.recaptcha['private_key']

Recaptcha.configure do |config|
  config.public_key  = SETTINGS.recaptcha['public_key']
  config.private_key = SETTINGS.recaptcha['private_key']
end
