class AddGameNameColumnToLogBooksTable < ActiveRecord::Migration
  def change
    add_column :log_books, :game_name, :string
  end
end
