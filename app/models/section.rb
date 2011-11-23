class Section < ActiveRecord::Base
  belongs_to :log_book
  
  has_many :world_objects, :dependent => :destroy
  has_many :section_properties, :dependent => :destroy
  
  accepts_nested_attributes_for :section_properties
  
  validates :name, :presence => true
  
  def sorted_properties
    section_properties.sort{|p1, p2| p1.sort_order <=> p2.sort_order}
  end
end