class Character < WorldObject
  belongs_to :log_book
  belongs_to :section
  # the parent/sub character associations are omitted, because it doesn't seem to make sense for this class
  
  has_many :properties
end