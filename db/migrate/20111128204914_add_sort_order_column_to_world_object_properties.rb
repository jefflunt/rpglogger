class AddSortOrderColumnToWorldObjectProperties < ActiveRecord::Migration
  def up
    add_column :world_object_properties, :sort_order, :integer, :default=> 0, :null => false
    
    WorldObjectProperty.reset_column_information
    WorldObjectProperty.all.each do |prop|
      prop.update_attribute(:sort_order, prop.section_property.sort_order)
    end
  end
  
  def down
    remove_column :world_object_properties, :sort_order
  end
end
