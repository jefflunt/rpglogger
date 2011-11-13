class Category < ActiveRecord::Base
  belongs_to :log_book
  
  has_many :world_objects
end