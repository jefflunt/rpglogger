require 'spec_helper'

describe SectionProperty do
  before(:each) do
    @world_object = Factory.create(:world_object)
    
    for i in 1..20 do
      section_property = Factory.create(:section_property, :section_id=>@world_object.section.id, :name=>"property#{i}", :data_type=>"string", :sort_order=>rand(10000))
      Factory.create(:world_object_property, :section_property_id=>section_property.id, :world_object_id=>@world_object.id, :string_value=>"value#{i}")
    end
  end
  
  it "should update the `sort_order` value of all child WorldObjectProperties upon saving" do
    section_property = @world_object.section.section_properties.first
    
    current_sort_order = section_property.sort_order
    new_sort_order = current_sort_order+25
    
    section_property.world_object_properties.each do |obj_prop|
      obj_prop.sort_order.should == current_sort_order
    end
    
    section_property.update_attribute(:sort_order, new_sort_order)
    
    section_property.world_object_properties.reload
    section_property.world_object_properties.each do |obj_prop|
      obj_prop.sort_order.should == new_sort_order
    end
  end
  
end