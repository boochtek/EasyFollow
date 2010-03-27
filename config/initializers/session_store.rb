# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_EasyFollow_session',
  :secret      => 'ade940b1adb9eca522238f5ff63dacb689f182260aafcc941ba0fcc3ea2fca2d1c50534a57badc5c52db2e0d0966dec60a252318bfedf84fdc95fe8eae4ae1a0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
