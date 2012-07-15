class Section < ActiveRecord::Base
  acts_as_paranoid
  
  belongs_to :log_book
  
  has_many :world_objects, order: "LOWER(name) ASC"
  has_many :section_properties, order: :sort_order
  
  accepts_nested_attributes_for :section_properties
  accepts_nested_attributes_for :world_objects
  
  validates :name, :presence => true
  
  scope :order_by_name, order("LOWER(name) ASC")
  
  def is_public?
    log_book.is_public?
  end
  
  def deleted?
    deleted_at != nil
  end
end