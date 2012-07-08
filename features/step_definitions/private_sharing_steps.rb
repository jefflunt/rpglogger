require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a user named "(.*?)" with provider "(.*?)" exists$/ do |nickname, provider|
  FactoryGirl.create(:user, nickname: nickname, provider: provider)
end

When /^the LogBook "(.*?)" is marked as private$/ do |title|
  @log_book = LogBook.find_by_title(title)
  @log_book.update_attribute(:is_public, false)
  @log_book.reload
end

Given /^the LogBook "(.*?)" is shared with "(.*?)"$/ do |log_book_title, shared_user_nickname|
  log_book = LogBook.find_by_title(log_book_title)
  user = User.find_by_nickname(shared_user_nickname)
  
  user.shared_log_books << log_book unless user.shared_log_books.include?(log_book)
end