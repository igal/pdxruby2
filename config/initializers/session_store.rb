# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pdxruby2_session',
  :secret      => 'b3f8283574bc72a79f9546988da474da432c43b6c653e73b9a14c08e9da70b16481b6d5b76a7a28e86695f262a379ae7e548d1ab3ba501ff469f683a5d261013'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
