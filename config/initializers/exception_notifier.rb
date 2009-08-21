# Configure the ExceptionNotifier plugin. NOTE: You must instantiate SETTINGS
# before this is done for this to work.

require 'etc'
require 'socket'

ExceptionNotifier.sender_address = "#{Etc.getlogin}@#{Socket.gethostname}"

ExceptionNotifier.exception_recipients = [SETTINGS.exception_notification_address]
