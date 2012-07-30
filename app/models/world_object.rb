class WorldObject < ActiveRecord::Base
  require 'populator'
  require 'faker'
  
  belongs_to :section
  has_many :world_object_properties, dependent: :destroy
  
  validates :name, :presence => true
    
  accepts_nested_attributes_for :world_object_properties
  
  scope :sorted_by_name, order("LOWER(name) ASC")
  scope :active, where("archived_at IS NULL")
  scope :archived, where("archived_at IS NOT NULL")
  
  def is_public?
    section.is_public?
  end
  
  def archived?
    archived_at != nil
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