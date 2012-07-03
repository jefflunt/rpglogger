class SectionProperty < ActiveRecord::Base
  after_save    :update_world_object_property_sort_order_attributes
  after_update  :update_world_object_property_sort_order_attributes
  
  belongs_to :section
  
  has_many :world_object_properties, dependent: :destroy
  
  scope :sort_order, order: "sort_order ASC"
  
  validates :name, :presence => true
  validates :data_type, :presence => true
  validates :sort_order, :presence => true
  
  def self.all_data_types
    ['boolean', 'integer', 'string', 'text']
  end
  
  private
    def update_world_object_property_sort_order_attributes
      if self.sort_order_changed?
        world_object_properties.each do |obj_prop|
          obj_prop.update_attribute(:sort_order, self.sort_order)
        end
      end
    end
end