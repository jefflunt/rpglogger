class NotesEntry < WorldObject
  belongs_to :log_book
  belongs_to :section
  # the parent/sub notes associations are omitted, because it doesn't seem to make sense for this class. tags would be used instead

  has_many :properties
end