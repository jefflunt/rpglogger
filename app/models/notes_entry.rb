class NotesEntry < ActiveRecord::Base
  belongs_to :log_book
  
  belongs_to :quest
end