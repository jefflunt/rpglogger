namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    puts "Populating. Enjoy this random pattern generator while you wait..."
    
    [Game, User, LogBook, Section, SectionProperty, WorldObject, WorldObjectProperty].each(&:delete_all)
    
    Game.populate 5 do |game|
      game.name = Faker::Name.name
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
      
      log_book.title = Populator.words(1..4)
      
      locations_section  = Section.create(:log_book_id => log_book.id, :name => 'locations')
      loc_name = SectionProperty.create(:section => locations_section, :name => 'name', :data_type => 'string', :sort_order => 1, :entry_type => 'plain')
      
      quests_section     = Section.create(:log_book_id => log_book.id, :name => 'quests')
      quest_name   = SectionProperty.create(:section => quests_section, :name => 'name',   :data_type => 'string', :sort_order => 1, :entry_type => 'plain')
      quest_detail = SectionProperty.create(:section => quests_section, :name => 'detail', :data_type => 'text',   :sort_order => 2, :entry_type => 'plain')
      
      journal_section = Section.create(:log_book_id => log_book.id, :name => 'journal')
      journal_title   = SectionProperty.create(:section => journal_section, :name => 'title', :data_type => 'string', :sort_order => 1, :entry_type => 'plain')
      jounral_entry   = SectionProperty.create(:section => journal_section, :name => 'entry', :data_type => 'text',   :sort_order => 2, :entry_type => 'plain')
      
      characters_section = Section.create(:log_book_id => log_book.id, :name => 'characters')
      character_name  = SectionProperty.create(:section => characters_section, :name => 'name',       :data_type => 'string',  :sort_order => 1, :entry_type => 'plain')
      character_level = SectionProperty.create(:section => characters_section, :name => 'level',      :data_type => 'integer', :sort_order => 2, :entry_type => 'plain')
      character_story = SectionProperty.create(:section => characters_section, :name => 'back story', :data_type => 'text',    :sort_order => 3, :entry_type => 'plain')
      
      rand(80).times do
        new_location = Location.new(:name => Populator.words(1..3), :section => locations_section)
        new_location.fake_fill_properties
      end
      
      rand(50).times do
        new_quest = Quest.new(:name => Populator.words(1..3), :section => quests_section)
        new_quest.fake_fill_properties
      end
      
      rand(35).times do
        new_journal_entry = NotesEntry.new(:name => Populator.words(1..3), :section => journal_section)
        new_journal_entry.fake_fill_properties
      end
      
      rand(3).times do
        new_character = Character.new(:name => Populator.words(1..3), :section => characters_section)
        new_character.fake_fill_properties
      end
    end
    
    puts ""

    # Samples
    #
    # Category.populate 20 do |category|
    #   category.name = Populator.words(1..3).titleize
    #   Product.populate 10..100 do |product|
    #     product.category_id = category.id
    #     product.name = Populator.words(1..5).titleize
    #     product.description = Populator.sentences(2..10)
    #     product.price = [4.99, 19.95, 100]
    #     product.created_at = 2.years.ago..Time.now
    #   end
    # end
    # 
    # Person.populate 100 do |person|
    #   person.name    = Faker::Name.name
    #   person.company = Faker::Company.name
    #   person.email   = Faker::Internet.email
    #   person.phone   = Faker::PhoneNumber.phone_number
    #   person.street  = Faker::Address.street_address
    #   person.city    = Faker::Address.city
    #   person.state   = Faker::Address.us_state_abbr
    #   person.zip     = Faker::Address.zip_code
    # end
  end
end