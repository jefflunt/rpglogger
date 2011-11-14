class Section < ActiveRecord::Base
  belongs_to :log_book
  
  has_many :section_properties, :class_name => 'SectionProperty'
  has_many :world_objects
end