# Extra libraries and features imported into "spec/spec_helper.rb"

require 'lib/authenticated_test_helper'
include AuthenticatedTestHelper

# Save the response.body to "/tmp/response.html", to aid manual debugging.
def save_body
  filename = "/tmp/response.html"
  bytes = File.open(filename, "w+"){|h| h.write(response.body)}
  return [filename, bytes]
end
