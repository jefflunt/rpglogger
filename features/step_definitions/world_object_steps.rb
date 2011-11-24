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

Given /^a WorldObjectProperty exists that points to SectionProperty "([^"]*)" and WorldObject "([^"]*)" with a value "([^"]*)"$/ do |section_prop_name, obj_name, prop_value|
  section_property = SectionProperty.find_by_name(section_prop_name)
  world_object = WorldObject.find_by_name(obj_name)
  
  new_world_object_property = WorldObjectProperty.new(
    :section_property_id=>section_property.id,
    :world_object_id=>world_object.id
  )
  
  case section_property.data_type
  when "boolean"
    case prop_value
    when "true"
      new_world_object_property.boolean_value = true
    else
      new_world_object_property.boolean_value = false
    end
  when "integer"
    new_world_object_property.integer_value = prop_value.to_i
  when "string"
    new_world_object_property.string_value = prop_value
  when "text"
    new_world_object_property.text_value = prop_value
  end
  
  new_world_object_property.save!
end

Then /^the total numberr of WorldObjectProperties should be "([^"]*)"$/ do |prop_count|
  WorldObjectProperty.count.should == prop_count.to_i
end
