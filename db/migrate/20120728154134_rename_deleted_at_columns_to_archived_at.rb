class RenameDeletedAtColumnsToArchivedAt < ActiveRecord::Migration
  def change
    rename_column :log_books,           :deleted_at, :archived_at
    rename_column :sections,            :deleted_at, :archived_at
    rename_column :section_properties,  :deleted_at, :archived_at
    rename_column :world_objects,       :deleted_at, :archived_at
  end
end
