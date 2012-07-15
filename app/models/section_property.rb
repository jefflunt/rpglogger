class SectionProperty < ActiveRecord::Base
  acts_as_paranoid
  
  belongs_to :section
  
  has_many :world_object_properties
  
  scope :sort_order, order: "sort_order ASC"
  
  validates :name, :presence => true
  validates :data_type, :presence => true
  validates :sort_order, :presence => true
  
  def self.all_data_types
    ['boolean', 'integer', 'string', 'text']
  end
  
  def is_public?
    section.is_public?
  end
end