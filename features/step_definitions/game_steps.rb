require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a game exists called "([^"]*)"$/ do |game_name|
  Game.create(:name=>game_name)
end
