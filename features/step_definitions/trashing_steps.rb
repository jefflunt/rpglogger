Then /^the LogBook "(.*?)" should be marked as deleted$/ do |log_book_title|
  LogBook.only_deleted.detect{|lb| lb.title = log_book_title}.deleted_at.should_not be nil
end

Then /^the Section "(.*?)" in "(.*?)" should be marked as deleted$/ do |section_name, log_book_title|
  LogBook.find_by_title(log_book_title).sections.only_deleted.detect{|s| s.name == section_name}.deleted_at.should_not be nil
end

Then /^the WorldObject "(.*?)" in "(.*?)" in "(.*?)" should be marked as deleted$/ do |world_object_name, section_name, log_book_title|
  LogBook.find_by_title(log_book_title).sections.find_by_name(section_name).world_objects.only_deleted.detect{|wo| wo.name == world_object_name}.deleted_at.should_not be nil
end