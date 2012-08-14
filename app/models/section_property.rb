class SectionProperty < ActiveRecord::Base  
  belongs_to :section
  
  has_many :world_object_properties, dependent: :destroy
  
  scope :sort_order, order: "sort_order ASC"
  scope :active, where("section_properties.archived_at IS NULL")
  scope :archived, where("section_properties.archived_at IS NOT NULL")
  
  validates :name, :presence => true
  validates :data_type, :presence => true
  validates :sort_order, :presence => true
  
  def archived?
    archived_at != nil
  end
  
  def self.all_data_types
    ['boolean', 'integer', 'string', 'text']
  end
  
  def is_public?
    section.is_public?
  end
end