class BeginningObjectStructure < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string    :login,               :null => false                # optional, you can use email instead, or both
      t.string    :email,               :null => false                # optional, you can use login instead, or both
      t.string    :crypted_password,    :null => false                # optional, see below
      t.string    :password_salt,       :null => false                # optional, but highly recommended
      t.string    :persistence_token,   :null => false                # required
      t.string    :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.string    :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability

      # Magic columns, just like ActiveRecord's created_at and updated_at. These are automatically maintained by Authlogic if they are present.
      t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
      t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
      t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
      t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns

      t.timestamps
    end

    create_table :games do |t|
      t.string :name, :null => false
      
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
      t.integer :dropper_id
      
      t.string :name, :null => false
      t.string :notes
      
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
    
    create_table :characters do |t|
      t.integer :log_book_id, :null => false
      
      t.string :name, :null => false
      t.string :notes
    end
    
    create_table :stats do |t|
      t.integer :character_id, :null => false
      
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
    drop_table :characters
    drop_table :stats
  end
end
