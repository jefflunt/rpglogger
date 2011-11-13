class WorldObject < ActiveRecord::Base
  belongs_to :log_book
  belongs_to :category
  belongs_to :location
  belongs_to :dropper, :class_name => 'WorldObject', :foreign_key => 'dropper_id'

  has_many :loot_items, :class_name => 'WorldObjects'
  has_many :properties
end