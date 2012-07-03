class Game < ActiveRecord::Base
  has_many :log_books, :dependent => :destroy

  validates :name, :presence => true

  def self.all_game_names
    Game.find_by_sql("SELECT DISTINCT name FROM games ORDER BY LOWER(name) ASC").collect{|game| game.name}
  end
  
end