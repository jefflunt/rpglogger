class Section < ActiveRecord::Base
  belongs_to :log_book
  
  has_many :world_objects, :dependent => :destroy
  has_many :section_properties, order: :sort_order, :dependent => :destroy
  
  accepts_nested_attributes_for :section_properties
  accepts_nested_attributes_for :world_objects
  
  validates :name, :presence => true
end