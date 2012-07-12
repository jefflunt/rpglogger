class CreateSharesTable < ActiveRecord::Migration
  def up
    create_table :shares do |t|
      t.integer :log_book_id
      t.integer :user_id
      t.string  :role, default: "editor"
    end
    
    add_index(:shares, [:log_book_id, :user_id], unique: true)
  end

  def down
    drop_table :shares
  end
end
