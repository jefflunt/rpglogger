class Game < ActiveRecord::Base
  has_many :log_books, :dependent => :destroy

  def characters
    log_books.collect{|lb| lb.world_objects.characters}
  end
end