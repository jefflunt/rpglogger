Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,  ENV['RPG_GOOGLE_ID'],       ENV['RPG_GOOGLE_SECRET'], { :scope => 'userinfo.email' }
  provider :twitter,        ENV['RPG_TW_CONSUMER_KEY'], ENV['RPG_TW_CONSUMER_SECRET']
  provider :facebook,       ENV['RPG_FB_APP_ID'],       ENV['RPG_FB_APP_SECRET'], {:scope => 'user_about_me'}
end
