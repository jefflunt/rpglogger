class LogBook < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  
  has_many :sections
  has_many :world_objects,  :through => :sections
  has_many :characters,     :through => :sections
  has_many :locations,      :through => :sections
  has_many :quests,         :through => :sections
  has_many :notes_entries,  :through => :sections
  
  def game_and_user_string
    user.login + " | " + game.name
  end
end