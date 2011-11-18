require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TW_CONSUMER_KEY'], ENV['TW_CONSUMER_SECRET']
  provider :facebook, ENV['FB_APP_ID'], ENV['FB_APP_SECRET'], {:scope => 'user_about_me'}
  provider :open_id, OpenID::Store::Filesystem.new('/tmp'), {:name => "google", :identifier => "https://www.google.com/accounts/o8/id" }
  
  # TODO
  # provider :open_id, OpenID::Store::Filesystem.new('/tmp'), {:name => "yahoo", :domain => "https://me.yahoo.com"}
  # AOL provider should be in here as well
end