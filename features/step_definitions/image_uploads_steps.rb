require 'uri'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

When /^I create a new SectionProperty called "(.*?)" of data type "(.*?)" on section "(.*?)"$/ do |section_property_name, data_type, section_name|
  step "I go to the edit Section page for Section \"#{section_name}\""
  step "I fill in \"section_properties[new_section_property_names]\" with \"#{section_property_name}\""
  step "I select \"#{data_type}\" from \"[data_type]\""
  step "I press \"Update attributes\""
end