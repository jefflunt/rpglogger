namespace :db do
  desc "Erase database"
  task :erase => :environment do
    puts "Erasing..."
    
    [User.unscoped, LogBook.unscoped, Section.unscoped, SectionProperty.unscoped, Share.unscoped, WorldObject.unscoped, WorldObjectProperty.unscoped].each(&:delete_all)
  end
  
  desc "Erase and fill database"
  task :populate => [:environment, :erase] do
    require 'populator'
    require 'faker'
    
    puts "Populating: enjoy this random pattern generator while you wait..."
    
    User.populate 50 do |user|
      user.provider = "rpglogger-auth"
      user.uid = rand(9000) + 999
      user.name = Faker::Internet.user_name
      user.nickname = Faker::Internet.user_name
    end

    User.all.each do |user|
      LogBook.populate 3 do |log_book|
        log_book.user_id = user.id
        log_book.game_name = Populator.words(1..4)
        log_book.is_public = true if rand(10) < 1

        log_book.title = Populator.words(1..4).titleize

        locations_section  = Section.create(:log_book_id => log_book.id, :name => 'Locations')

        quests_section  = Section.create(:log_book_id => log_book.id, :name => 'Quests')
        quest_detail    = SectionProperty.create(:section => quests_section, :name => 'Detail',     :data_type => 'text',    :sort_order => 1)
        quest_completed = SectionProperty.create(:section => quests_section, :name => 'Completed?', :data_type => 'boolean', :sort_order => 2)

        journal_section = Section.create(:log_book_id => log_book.id, :name => 'Journal')
        jounral_entry   = SectionProperty.create(:section => journal_section, :name => 'Entry', :data_type => 'text',   :sort_order => 1)

        characters_section = Section.create(:log_book_id => log_book.id, :name => 'Characters')
        character_level = SectionProperty.create(:section => characters_section, :name => 'Level',      :data_type => 'integer', :sort_order => 1)
        character_story = SectionProperty.create(:section => characters_section, :name => 'Back Story', :data_type => 'text',    :sort_order => 2)

        (5 + rand(80)).times do
          new_location = WorldObject.new(:name => Populator.words(1..3), :section => locations_section)
          new_location.fake_fill_properties
        end

        (5 + rand(50)).times do
          new_quest = WorldObject.new(:name => Populator.words(1..3), :section => quests_section)
          new_quest.fake_fill_properties
        end

        (5 + rand(35)).times do
          new_journal_entry = WorldObject.new(:name => Populator.words(1..3), :section => journal_section)
          new_journal_entry.fake_fill_properties
        end

        (2 + rand(3)).times do
          new_character = WorldObject.new(:name => Populator.words(1..3), :section => characters_section)
          new_character.fake_fill_properties
        end
      end
    end
    
    User.all.each do |user|
      while user.shared_log_books.count < (2 + rand(3))
        log_book = LogBook.order("RANDOM()").limit(1).first
        user.shared_log_books << log_book unless user.shared_log_books.include?(log_book)
      end
    end
    
    puts ""
  end
end
