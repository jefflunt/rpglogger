class AddIsPublicFieldToLogBooks < ActiveRecord::Migration
  def change
    add_column :log_books, :is_public, :boolean, default: false
  end
end
