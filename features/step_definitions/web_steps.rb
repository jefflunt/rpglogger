require 'uri'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^pending$/ do
  # Essentially allows marking an entire scenario as "pending", as opposed to just a single step
  # Useful when you have multiple tests failing, and you want to filter out a few, but still see
  # "Pending" in the cucumber results
  # Ref.: http://stackoverflow.com/questions/3064078/how-do-you-mark-a-cucumber-scenario-as-pending
  pending
end

# Then I should see a link named "Buy this widget" in the "Product Details" section
Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

When /^(?:|I )follow "([^\"]*)"$/ do |link|
  click_link(link)
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^debug$/ do
  debugger
end