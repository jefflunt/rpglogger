require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

When /^the LogBook "(.*?)" is marked as public$/ do |title|
  @log_book = LogBook.find_by_title(title)
  @log_book.update_attribute(:is_public, true)
  @log_book.reload
end

When /^the LogBook "(.*?)" is marked as private$/ do |title|
  @log_book = LogBook.find_by_title(title)
  @log_book.update_attribute(:is_public, false)
  @log_book.reload
end
