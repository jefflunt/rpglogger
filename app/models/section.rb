class Section < ActiveRecord::Base
  belongs_to :log_book
  
  has_many :world_objects, order: "LOWER(name) ASC", dependent: :destroy
  has_many :section_properties, order: :sort_order, dependent: :destroy
  
  accepts_nested_attributes_for :section_properties
  accepts_nested_attributes_for :world_objects
  
  validates :name, :presence => true
  
  scope :order_by_name, order("LOWER(name) ASC")
  scope :active, where("sections.archived_at IS NULL")
  scope :archived, where("sections.archived_at IS NOT NULL")
    
  def is_public?
    log_book.is_public?
  end
  
  def archived?
    archived_at != nil
  end
end