require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

When /^the LogBook "(.*?)" is marked as public$/ do |title|
  @log_book = LogBook.find_by_title(title)
  @log_book.update_attribute(:is_public, true)
  @log_book.reload
end

When /^I try to change the name of "(.*?)" in "(.*?)" of "(.*?)" to "(.*?)"$/ do |world_object_name, section_name, log_book_title, new_world_object_name|
  @log_book = LogBook.find_by_title(log_book_title)
  @section = @log_book.sections.find_by_name(section_name)
  @world_object = @section.world_objects.find_by_name(world_object_name)
  
  put section_world_object_path(@section, @world_object), world_object: {name: new_world_object_name}
end

When /^I try to delete the WorldObject "(.*?)" in "(.*?)" of "(.*?)"$/ do |world_object_name, section_name, log_book_title|
  @log_book = LogBook.find_by_title(log_book_title)
  @section = @log_book.sections.find_by_name(section_name)
  @world_object = @section.world_objects.find_by_name(world_object_name)
  
  delete section_world_object_path(@section, @world_object)
end
