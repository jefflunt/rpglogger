class BeginningObjectStructure < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :nickname

      t.timestamps
    end

    create_table :games do |t|
      t.string :name, :null => false
      
      t.timestamps
    end
        
    create_table :log_books do |t|
      t.integer :user_id, :null => false
      t.integer :game_id, :null => false
      
      t.string :title, :null => false
      
      t.timestamps
    end
            
    create_table :sections do |t|
      t.integer :log_book_id, :null => false
      
      t.string :name, :null => false
    end
    
    create_table :section_properties do |t|
      t.integer :section_id, :null => false
      
      t.string :name, :null => false
      t.string :data_type, :null => false
      t.integer :sort_order, :null => false
    end
    
    create_table :world_objects do |t|
      t.integer :section_id, :null => false
      t.integer :parent_object_id
      
      t.string :name, :null => false
    end
        
    create_table :world_object_properties do |t|
      t.integer :world_object_id, :null => false
      t.integer :section_property_id, :null => false
      
      t.integer   :integer_value
      t.boolean   :boolean_value
      t.string    :string_value
      t.text      :text_value
            
      t.timestamps
    end
  end

  def down
    drop_table :users
    drop_table :games
    drop_table :log_books
    drop_table :sections
    drop_table :section_properties
    drop_table :world_objects
    drop_table :world_object_properties
  end
end
