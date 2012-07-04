class RemoveParentIdFromWorldObjectProperties < ActiveRecord::Migration
  def up
    remove_column :world_objects, :parent_object_id
  end

  def down
    add_column :world_objects, :parent_object_id, :integer
  end
end
