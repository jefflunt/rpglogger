class SectionProperty < ActiveRecord::Base
  belongs_to :section
  
  has_many :world_object_properties, :dependent => :destroy
  
  def self.all_data_types
    ['boolean', 'integer', 'string', 'text']
  end
end