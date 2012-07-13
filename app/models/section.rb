class Section < ActiveRecord::Base
  acts_as_paranoid
  
  belongs_to :log_book
  
  has_many :world_objects
  has_many :section_properties, order: :sort_order
  
  accepts_nested_attributes_for :section_properties
  accepts_nested_attributes_for :world_objects
  
  validates :name, :presence => true
  
  def is_public?
    log_book.is_public?
  end
end