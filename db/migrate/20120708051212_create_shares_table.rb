class CreateSharesTable < ActiveRecord::Migration
  def up
    create_table :shares, id: false do |t|
      t.integer :log_book_id
      t.integer :user_id
      t.string  :access_level, default: "read-only"
    end
    
    add_index(:shares, [:log_book_id, :user_id], unique: true)
  end

  def down
    drop_table :shares
  end
end
