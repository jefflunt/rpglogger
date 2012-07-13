class AddParanoiaColumns < ActiveRecord::Migration
  def change
    add_column :log_books,     :deleted_at, :datetime
    add_column :sections,      :deleted_at, :datetime
    add_column :world_objects, :deleted_at, :datetime
  end
end
