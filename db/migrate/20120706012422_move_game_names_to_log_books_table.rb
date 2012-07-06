class MoveGameNamesToLogBooksTable < ActiveRecord::Migration
  def up
    LogBook.all.each do |lb|
      lb.update_attribute(:game_name, lb.game.name)
    end
    
    remove_column :log_books, :game_id
    drop_table :games
  end

  def down
    add_column :log_books, :game_id, :integer
    LogBook.reset_column_information
    
    create_table :games do |t|
      t.string :name, :null => false
      
      t.timestamps
    end
    
    Game.reset_column_information
    game_names = LogBook.select("game_name").collect{|log_book| log_book.game_name}.uniq
    
    game_names.each do |gn|
      Game.create(name: gn)
    end
    
    LogBook.all.each do |lb|
      lb.update_attribute(:game_id, Game.find_by_name(lb.game_name).id)
    end
  end
end
