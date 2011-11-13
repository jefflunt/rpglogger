class Quest < ActiveRecord::Base
  belongs_to :log_book
  
  has_many :notes_entries
end