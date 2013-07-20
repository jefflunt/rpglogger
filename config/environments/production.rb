Rpglogger::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.smtp_settings = {
    :enable_starttls_auto => true,
    :address => ENV['RPG_EMAIL_SERVER'],
    :port => ENV['RPG_EMAIL_PORT'].to_i,
    :authentication => 'plain',
    :domain => ENV['RPG_EMAIL_DOMAIN'],
    :user_name => ENV['RPG_EMAIL_USERNAME'],
    :password => ENV['RPG_EMAIL_PASSWORD']
  }

  HowSlow.configure(
    :email_recipients     => ENV['RPG_EMAIL_TO'].split(' ').join(','),
    :email_sender_address => ENV['RPG_EMAIL_FROM'],
    :email_actions_max    => 100
  )
end
