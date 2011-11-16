class LogBook < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  
  has_many :sections
  has_many :world_objects,  :through => :sections
  
  accepts_nested_attributes_for :sections
end