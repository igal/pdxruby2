# Read "config/settings.yml" and create a SETTINGS OpenStruct object.

require 'settings_reader'

filename_relative = "config/settings.yml"
filename_complete = "#{RAILS_ROOT}/#{filename_relative}"

if File.exist?(filename_complete)
  SETTINGS = SettingsReader.read(filename_complete)
else
  puts <<-TEXT
+---[ ERROR ]-----------------------------------------------------------
| You must create a "#{filename_relative}" file to store your settings.
| You should make this by copying "#{filename_relative}.sample",
| which provides further instructions on what to put in this file.
+-----------------------------------------------------------------------
  TEXT
  raise IOError, "Couldn't read settings from: #{filename_relative}"
end
