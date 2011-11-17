namespace :db do
  desc "Erase database"
  task :erase => :environment do
    puts "Erasing..."
    
    [Game, User, LogBook, Section, SectionProperty, WorldObject, WorldObjectProperty].each(&:delete_all)
  end
  
  desc "Erase and fill database"
  task :populate => [:environment, :erase] do
    require 'populator'
    require 'faker'
    
    Game.populate 5 do |game|
      game.name = Populator.words(1..2).titleize
    end
    
    User.populate 50 do |user|
      user.login = Faker::Internet.user_name
      user.email = Faker::Internet.email
      
      user.crypted_password     = "password"
      user.password_salt        = "salt"
      user.persistence_token    = "persistence-token"
      user.single_access_token  = "single-access-token"
      user.perishable_token     = "perishable_token"
      user.login_count          = 0
      user.failed_login_count   = 0
    end
    
    LogBook.populate 15 do |log_book|
      log_book.game_id = Game.all.collect{|g| g.id}
      log_book.user_id = User.all.collect{|u| u.id}
      
      log_book.title = Populator.words(1..4).titleize
      
      locations_section  = Section.create(:log_book_id => log_book.id, :name => 'locations')
      
      quests_section     = Section.create(:log_book_id => log_book.id, :name => 'quests')
      quest_detail    = SectionProperty.create(:section => quests_section, :name => 'detail',     :data_type => 'text',    :sort_order => 1)
      quest_completed = SectionProperty.create(:section => quests_section, :name => 'completed?', :data_type => 'boolean', :sort_order => 2)
      
      journal_section = Section.create(:log_book_id => log_book.id, :name => 'journal')
      jounral_entry   = SectionProperty.create(:section => journal_section, :name => 'entry', :data_type => 'text',   :sort_order => 1)
      
      characters_section = Section.create(:log_book_id => log_book.id, :name => 'characters')
      character_level = SectionProperty.create(:section => characters_section, :name => 'level',      :data_type => 'integer', :sort_order => 1)
      character_story = SectionProperty.create(:section => characters_section, :name => 'back story', :data_type => 'text',    :sort_order => 2)
      
      rand(80).times do
        new_location = WorldObject.new(:name => Populator.words(1..3), :section => locations_section)
        new_location.fake_fill_properties
      end
      
      rand(50).times do
        new_quest = WorldObject.new(:name => Populator.words(1..3), :section => quests_section)
        new_quest.fake_fill_properties
      end
      
      rand(35).times do
        new_journal_entry = WorldObject.new(:name => Populator.words(1..3), :section => journal_section)
        new_journal_entry.fake_fill_properties
      end
      
      rand(3).times do
        new_character = WorldObject.new(:name => Populator.words(1..3), :section => characters_section)
        new_character.fake_fill_properties
      end
    end
    
    puts ""
  end
end