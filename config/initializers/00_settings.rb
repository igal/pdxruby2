# Read "config/settings.yml" and create a SETTINGS OpenStruct object.

require 'settings_reader'

filename_relative_real = "config/settings.yml"
filename_absolute_real = "#{RAILS_ROOT}/#{filename_relative_real}"
filename_relative_sample = "#{filename_relative_real}.sample"
filename_absolute_sample = "#{RAILS_ROOT}/#{filename_relative_sample}"

if File.exist?(filename_absolute_real)
  #IK# puts "* Loading custom SETTINGS from: #{filename_relative_sample}"
  SETTINGS = SettingsReader.read(filename_absolute_real)
else
  if RAILS_ENV == "production"
    puts <<-TEXT
+---[ ERROR ]-----------------------------------------------------------
| You MUST create a "#{filename_relative_real}" file to store your settings.
| You should make this by copying "#{filename_relative_sample}",
| which provides further instructions on what to put in this file.
+-----------------------------------------------------------------------
    TEXT
    raise IOError, "Couldn't read settings from: #{filename_relative_real}"
  else
    puts "* Loading sample SETTINGS from: #{filename_relative_sample}"
    SETTINGS = SettingsReader.read(filename_absolute_sample)
  end
end
