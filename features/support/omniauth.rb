OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:facebook, {
  :info => {
    :uid => '12345',
    :name => 'Foo Man',
    :nickname => 'fooman',
  }
})