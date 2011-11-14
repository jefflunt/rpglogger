class WorldObjectProperty < ActiveRecord::Base
  belongs_to :section_property
  belongs_to :world_object
end