class SectionProperty < ActiveRecord::Base
  belongs_to :section
  
  has_many :world_object_properties
end