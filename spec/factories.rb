require 'populator'
require 'faker'

FactoryGirl.define do

  factory :user do |u|
    u.provider        {"rpglogger-auth"}
    u.sequence(:uid)  {|uid| uid}
    u.name		        {Faker::Name.first_name + ' ' + Faker::Name.last_name}
    u.nickname        {Faker::Internet.user_name}
  end

  factory :log_book do |l|
    user
    
    l.title           {Populator.words(1..4)}
    l.game_name       {Populator.words(1..4)}
  end

  factory :section do |s|
    log_book
    
    s.name            {Populator.words(1..2)}
  end

  factory :section_property do |s|
    section
    
    s.name                    {Populator.words(1)}
    s.data_type               {['boolean', 'string', 'text', 'integer'][rand(4)]}
    s.sequence(:sort_order)   {|sort_order| sort_order}
  end
  
  factory :share do |s|
    log_book
    user
    
    s.access_level  {"read-only"}
  end

  factory :world_object do |w|
    section
    
    w.name            {Populator.words(1..3)}
  end

  factory :world_object_property do |w|
    world_object
    section_property
  
    w.integer_value   {rand(1000)}
    w.boolean_value   {[true, false][rand(2)]}
    w.string_value    {Populator.words(1..5)}
    w.text_value      {Populator.sentences(2..25)}
  end

end