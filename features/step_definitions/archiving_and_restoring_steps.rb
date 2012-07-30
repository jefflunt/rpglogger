Then /^the LogBook "(.*?)" should be marked as archived$/ do |log_book_title|
  LogBook.archived.detect{|lb| lb.title = log_book_title}.archived_at.should_not be nil
end

Then /^the LogBook "(.*?)" should NOT be marked as archived$/ do |log_book_title|
  LogBook.find_by_title(log_book_title).archived_at.should be nil
end

Then /^the Section "(.*?)" in "(.*?)" should be marked as archived$/ do |section_name, log_book_title|
  LogBook.find_by_title(log_book_title).sections.archived.detect{|s| s.name == section_name}.archived_at.should_not be nil
end

Then /^the Section "(.*?)" in "(.*?)" should NOT be marked as archived$/ do |section_name, log_book_title|
  LogBook.find_by_title(log_book_title).sections.find_by_name(section_name).archived_at.should be nil
end

Then /^the WorldObject "(.*?)" in "(.*?)" in "(.*?)" should be marked as archived$/ do |world_object_name, section_name, log_book_title|
  LogBook.find_by_title(log_book_title).sections.find_by_name(section_name).world_objects.archived.detect{|wo| wo.name == world_object_name}.archived_at.should_not be nil
end

Then /^the WorldObject "(.*?)" in "(.*?)" in "(.*?)" should NOT be marked as archived$/ do |world_object_name, section_name, log_book_title|
  LogBook.find_by_title(log_book_title).sections.find_by_name(section_name).world_objects.find_by_name(world_object_name).archived_at.should be nil
end