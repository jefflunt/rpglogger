class LogBook < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  
  has_many :sections, :dependent => :destroy
  has_many :world_objects, :through => :sections, :dependent => :destroy
  
  accepts_nested_attributes_for :sections
end