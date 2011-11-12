class AddCharacterAndStatsTables < ActiveRecord::Migration
  def up
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
    drop_table :characters
    drop_table :stats
  end
end
