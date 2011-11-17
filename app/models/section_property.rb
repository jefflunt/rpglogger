class SectionProperty < ActiveRecord::Base
  belongs_to :section
  
  has_many :world_object_properties, :dependent => :destroy
  
  validate :name, :presence => true
  validate :data_type, :presence => true
  validate :sort_order, :presence => true
  
  def self.all_data_types
    ['boolean', 'integer', 'string', 'text']
  end
end