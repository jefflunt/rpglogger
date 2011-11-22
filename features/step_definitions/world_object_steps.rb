require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a WorldObject exists called "([^"]*)" in "([^"]*)"$/ do |obj_name, section_name|
  section = Section.find_by_name(section_name)
  
  new_world_object = WorldObject.create(:name=>obj_name, :section_id=>section.id)
end

When /^I access the WorldObject "([^"]*)" in "([^"]*)"$/ do |obj_name, section_name|
  section = Section.find_by_name(section_name)
  world_object = WorldObject.find_by_name_and_section_id(obj_name, section.id)

  visit section_world_object_path(section, world_object)
end

When /^I edit the WorldObject "([^"]*)" in "([^"]*)"$/ do |obj_name, section_name|
  section = Section.find_by_name(section_name)
  world_object = WorldObject.find_by_name_and_section_id(obj_name, section.id)
  
  visit edit_section_world_object_path(section, world_object)
end

Then /^the total number of WorldObjects should be "([^"]*)"$/ do |obj_num|
  WorldObject.count.should == obj_num.to_i
end

Then /^the total number of WorldObjectProperties should be "([^"]*)"$/ do |obj_prop_num|
  WorldObjectProperty.count.should == obj_prop_num.to_i
end
