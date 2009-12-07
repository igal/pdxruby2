# Configure the ExceptionNotifier plugin. NOTE: You must instantiate SETTINGS
# before this is done for this to work.

require 'etc'
require 'socket'

ExceptionNotifier.configure_exception_notifier do |c|
  c[:exception_recipients] = [SETTINGS.exception_notification_address]
  c[:sender_address] = "#{Etc.getlogin}@#{Socket.gethostname}"
  c[:skip_local_notification]  = false
end
