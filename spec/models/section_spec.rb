require 'spec_helper'

describe Section do
  before(:each) do
    @section = Factory.create(:section)
    
    for i in 1..20 do
      section_property = Factory.create(:section_property, :section_id=>@section.id, :name=>"property#{i}", :data_type=>"string", :sort_order=>rand(10000))
    end
  end
  
  it "should have a method called 'sorted_properties' the returns its SectionProperties in sort_order" do
    sorted_section_properties = @section.sorted_properties
    
    last_sort_order = 0
    sorted_section_properties.each do |prop|
      prop.sort_order.should >= last_sort_order
      last_sort_order = prop.sort_order
    end
  end
end