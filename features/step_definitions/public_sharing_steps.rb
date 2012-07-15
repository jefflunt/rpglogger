require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

When /^the LogBook "(.*?)" is marked as public$/ do |title|
  @log_book = LogBook.find_by_title(title)
  @log_book.update_attribute(:is_public, true)
  @log_book.reload
end

When /^I try to change the name of WorldObject "(.*?)" in "(.*?)" of "(.*?)" to "(.*?)"$/ do |world_object_name, section_name, log_book_title, new_world_object_name|
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

When /^I try to change the name of Section "(.*?)" of "(.*?)" to "(.*?)"$/ do |section_name, log_book_title, new_section_name|
  @log_book = LogBook.find_by_title(log_book_title)
  @section = @log_book.sections.find_by_name(section_name)
  
  put section_path(@section), section: {name: new_section_name}
end

When /^I try to delete the Section "(.*?)" of "(.*?)"$/ do |section_name, log_book_title|
  @log_book = LogBook.find_by_title(log_book_title)
  @section = @log_book.sections.find_by_name(section_name)
  
  delete section_path(@section)
end

When /^I try to change the name of LogBook "(.*?)" to "(.*?)"$/ do |log_book_title, new_log_book_title|
  @log_book = LogBook.find_by_title(log_book_title)
  
  put log_book_path(@log_book), log_book: {title: new_log_book_title}
end

When /^I try to delete the LogBook "(.*?)"$/ do |log_book_title|
  @log_book = LogBook.find_by_title(log_book_title)
  
  delete log_book_path(@log_book)
end

Then /^"(.*?)" should be marked as public$/ do |log_book_title|
  LogBook.find_by_title(log_book_title).is_public.should be true
end

Then /^"(.*?)" should be marked as private$/ do |log_book_title|
  LogBook.find_by_title(log_book_title).is_public.should be false
end