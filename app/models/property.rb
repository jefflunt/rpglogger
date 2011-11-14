class Property < ActiveRecord::Base
  belongs_to :world_object
  belongs_to :section_property
end