class Location < WorldObject
  belongs_to :log_book
  belongs_to :section
  belongs_to :parent_location, :class_name => 'WorldObject', :foreign_key => 'parent_object_id'

  has_many :sub_locations, :class_name => 'WorldObjects'
  has_many :properties
end