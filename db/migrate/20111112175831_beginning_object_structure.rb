class BeginningObjectStructure < ActiveRecord::Migration
  def up
    create_table :games do |t|
      t.string :name, :null => false
      
      t.timestamps
    end
    
    create_table :users do |t|
      t.string :email, :null => false
      t.string :login, :null => false
      
      t.timestamps
    end
    
    create_table :log_books do |t|
      t.integer :user_id, :null => false
      t.integer :game_id, :null => false
      
      t.timestamps
    end
    
    create_table :quests do |t|
      t.integer :log_book_id, :null => false
      t.string :name, :null => false
    end
    
    create_table :notes_entries do |t|
      t.integer :log_book_id, :null => false
      t.integer :quest_id
      
      t.text :text, :null => false
      
      t.timestamps
    end
    
    create_table :locations do |t|
      t.integer :log_book_id, :null => false
      t.string :name, :null => false
      t.string :area
      t.text :details
      
      t.timestamps
    end
    
    create_table :categories do |t|
      t.integer :log_book_id, :null => false
      
      t.string :name, :null => false
      
      t.timestamps
    end
    
    create_table :world_objects do |t|
      t.integer :log_book_id, :null => false
      t.integer :category_id, :null => false
      t.integer :location_id, :null => false
      t.integer :looted_from_id, :null => false
      
      t.string :name, :null => false
      
      t.timestamps
    end
    
    create_table :properties do |t|
      t.integer :world_object_id, :null => false
      
      t.string :name, :null => false
      t.string :data_type, :null => false
      t.string :display_type, :null => false
      
      t.string    :lookup_value      
      t.integer   :integer_value
      t.decimal   :decimal_value
      t.datetime  :datetime_value
      t.boolean   :boolean_value
      
      t.string :string_value
      t.text   :text_value
    end
  end

  def down
    drop_table :games
    drop_table :users
    drop_table :log_books
    drop_table :quests
    drop_table :notes_entries
    drop_table :locations
    drop_table :categories
    drop_table :world_objects
    drop_table :properties
  end
end
