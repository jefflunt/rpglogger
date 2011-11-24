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

Then /^the total number of Sections should be "([^"]*)"$/ do |section_num|
  Section.count.should == section_num.to_i
end

Then /^the total number of SectionProperties should be "([^"]*)"$/ do |prop_count|
  SectionProperty.count.should == prop_count.to_i
end

Given /^a SectionProperty exists called "([^"]*)" in "([^"]*)"$/ do |prop_name, section_name|
  Factory.create(:section_property, :name=>prop_name, :section_id=>Section.find_by_name(section_name).id)
end
