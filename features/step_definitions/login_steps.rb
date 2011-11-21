require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^I am signed in with "([^"]*)"$/ do |provider|
  visit "/auth/#{provider.downcase}"
end

When /^I sign out$/ do
  visit signout_path
end
