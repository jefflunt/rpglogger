require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a Section exists called "([^"]*)" in "([^"]*)"$/ do |section_name, log_book_title|
  log_book = LogBook.find_by_title(log_book_title)
  
  new_section = Section.create(:name=>section_name, :log_book_id=>log_book.id)
end

When /^I access the Section "([^"]*)"$/ do |section_name|
  visit section_path(Section.find_by_name(section_name))
end

When /^I edit the Section "([^"]*)"$/ do |section_name|
  visit edit_section_path(Section.find_by_name(section_name))
end

