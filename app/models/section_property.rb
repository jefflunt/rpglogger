class SectionProperty < ActiveRecord::Base
  belongs_to :section
  
  has_many :world_object_properties, :dependent => :destroy
  
  validates :name, :presence => true
  validates :data_type, :presence => true
  validates :sort_order, :presence => true
  
  def self.all_data_types
    ['boolean', 'integer', 'string', 'text']
  end
end