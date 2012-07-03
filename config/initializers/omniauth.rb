Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['RPG_TW_CONSUMER_KEY'], ENV['RPG_TW_CONSUMER_SECRET']
  provider :facebook, ENV['RPG_FB_APP_ID'], ENV['RPG_FB_APP_SECRET'], {:scope => 'user_about_me'}
  
  # TODO
  # provider :google, 'rpglogger.com', 'oauth_secret', :scope => 'https://mail.google.com/mail/feed/atom/'
  # provider :open_id, OpenID::Store::Filesystem.new('/tmp'), {:name => "yahoo", :domain => "https://me.yahoo.com"}
  # AOL provider should probably be in here as well
end
