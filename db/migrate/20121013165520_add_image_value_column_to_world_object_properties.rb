class AddImageValueColumnToWorldObjectProperties < ActiveRecord::Migration
  def change
    add_column :world_object_properties, :image_value, :string
  end
end
