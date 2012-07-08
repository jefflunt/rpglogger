require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a user named "(.*?)" with provider "(.*?)" and uid "(.*?)" exists$/ do |nickname, provider, uid|
  FactoryGirl.create(:user, nickname: nickname, provider: provider, uid: uid)
end

When /^the LogBook "(.*?)" is marked as private$/ do |title|
  @log_book = LogBook.find_by_title(title)
  @log_book.update_attribute(:is_public, false)
  @log_book.reload
end

Given /^the LogBook "(.*?)" is shared with "(.*?)"$/ do |log_book_title, shared_user_nickname|
  log_book = LogBook.find_by_title(log_book_title)
  user = User.find_by_nickname(shared_user_nickname)
  
  user.shared_log_books << log_book unless log_book.owned_by?(user) || log_book.shared_with?(user)
end

Given /^the LogBook "(.*?)" is NOT shared with "(.*?)"$/ do |log_book_title, not_shared_user_nickname|
  log_book = LogBook.find_by_title(log_book_title)
  user = User.find_by_nickname(not_shared_user_nickname)
  
  user.shared_log_books.delete(log_book)
end

Given /^the number of users who have shared access to "(.*?)" should be (\d+)$/ do |log_book_title, num_shared_access_users|
  log_book = LogBook.find_by_title(log_book_title)
  log_book.shared_users.count.should be num_shared_access_users.to_i
end

Given /^the number of LogBooks shared with "(.*?)" is (\d+)$/ do |user_nickname, num_shared_log_books|
  User.find_by_nickname(user_nickname).shared_log_books.count.should be num_shared_log_books.to_i
end
