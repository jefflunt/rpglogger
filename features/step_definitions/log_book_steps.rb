require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a LogBook exists called "([^"]*)" for game "([^"]*)" and owned by "([^"]*)"$/ do |log_book_title, game_name, nickname|
  user = User.find_or_create_by_nickname(nickname)
  game = Factory.create(:game, :name=>game_name)
  
  log_book = Factory.create(:log_book, :title=>log_book_title, :game_id=>game.id, :user_id=>user.id)
end

Given /^a WorldObject exists called "([^"]*)" in section "([^"]*)" of "([^"]*)"$/ do |object_name, section_name, log_book_title|
  log_book = LogBook.find_by_title(log_book_title)
  section = Factory.create(:section, :name=>section_name, :log_book_id=>log_book.id)
  world_object = Factory.create(:world_object, :name=>object_name, :section_id=>section.id)
end

Then /^"([^"]*)" should own "([^"]*)" LogBooks$/ do |nickname, num_log_books|
  user = User.find_by_nickname(nickname)
  user.log_books.count.should be num_log_books.to_i
end

When /^I access the LogBook "([^"]*)"$/ do |log_book_title|
  visit log_book_path(LogBook.find_by_title(log_book_title))
end

When /^I edit the LogBook "([^"]*)"$/ do |log_book_title|
  visit edit_log_book_path(LogBook.find_by_title(log_book_title))
end
