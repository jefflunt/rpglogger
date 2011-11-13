class LogBook < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  
  has_many :characters
  has_many :locations
  has_many :quests
  has_many :notes_entries
  has_many :categories
  has_many :world_objects
end