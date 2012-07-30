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

Then /^the total number of active Sections should be (\d+)$/ do |section_num|
  Section.active.count.should == section_num.to_i
end

Then /^the total number of active SectionProperties should be (\d+)$/ do |prop_count|
  SectionProperty.active.count.should == prop_count.to_i
end

Given /^a SectionProperty exists called "(.*?)" of data type "(.*?)" in "(.*?)"$/ do |prop_name, data_type, section_name|
  section = Section.find_by_name(section_name)
  section.section_properties.create(name: prop_name, data_type: data_type)
end
