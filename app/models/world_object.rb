class WorldObject < ActiveRecord::Base
  require 'populator'
  require 'faker'
  
  belongs_to :section
  belongs_to :parent_object, :class_name => 'WorldObject', :foreign_key => 'parent_object_id'

  has_many :child_objects, :class_name => 'WorldObject', :foreign_key => 'parent_object_id', :dependent => :nullify
  has_many :world_object_properties, :dependent => :destroy
  
  validates :name, :presence => true
    
  accepts_nested_attributes_for :world_object_properties
  
  def sorted_properties
    world_object_properties.sort{|p1, p2| p1.sort_order <=> p2.sort_order}
  end
  
  def fake_fill_properties
    name = Populator.words(1..4)
    section.section_properties.each do |sp|
      new_property = WorldObjectProperty.new(:world_object => self, :section_property => sp)
      
      print (['\\', '/', '_', '|'])[rand(4)]
      
      case sp.data_type
      when 'integer'
        new_property.integer_value = rand(100)
      when 'boolean'
        new_property.boolean_value = rand(2) == 1 ? true : false
      when 'string'
        new_property.string_value = Populator.words(1..5)
      when 'text'
        new_property.text_value = Faker::Lorem.paragraph(rand(5))
      end
      
      new_property.save!
    end
    
    save!
  end
end