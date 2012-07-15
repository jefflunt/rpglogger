class AddDeletedAtFieldToSectionProperties < ActiveRecord::Migration
  def change
    add_column :section_properties, :deleted_at, :datetime
  end
end
