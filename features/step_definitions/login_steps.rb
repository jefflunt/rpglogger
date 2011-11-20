require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^I am signed in with "([^"]*)"$/ do |provider|
  visit "/auth/#{provider.downcase}"
end

Given /^I log in as the player who created "([^"]*)" via "([^"]*)"$/ do |log_book_title, provider|
  Given "I am signed in with #{provider}"
  
  log_book = LogBook.find_by_title_and_user_id(log_book_title)
  session.create(log_book.user)
end
