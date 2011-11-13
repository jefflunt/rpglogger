class Character < ActiveRecord::Base
  belongs_to :log_book
  
  has_many :stats
end