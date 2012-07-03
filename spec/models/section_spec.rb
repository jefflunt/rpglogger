require 'spec_helper'

describe Section do
  before(:each) do
    @section = FactoryGirl.create(:section)
    
    for i in 1..20 do
      section_property = FactoryGirl.create(:section_property, :section_id=>@section.id, :name=>"property#{i}", :data_type=>"string", :sort_order=>rand(10000))
    end
  end
  
  it "should return its SectionProperties in the correctly sorted order" do
    last_sort_order = 0
    @section.section_properties.each do |prop|
      prop.sort_order.should >= last_sort_order
      last_sort_order = prop.sort_order
    end
  end
end