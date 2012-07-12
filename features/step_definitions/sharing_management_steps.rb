Given /^the number of editor users on "(.*?)" should be (\d+)$/ do |log_book_title, num_editor_users|
  log_book = LogBook.find_by_title(log_book_title)
  log_book.shares.find_all_by_role("editor").count.should == num_editor_users.to_i
end