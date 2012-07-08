Capybara.default_host = 'http://rpglogger.com'
OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:facebook, {
  :info => {
    :uid => '1234',
    :name => 'Facebook user',
    :nickname => 'facebook_user',
  }
})

OmniAuth.config.add_mock(:google_oauth2, {
  :info => {
    :uid => '1234',
    :name => 'Google user',
    :nickname => 'google_user',
  }
})