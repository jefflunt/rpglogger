class SectionProperty < ActiveRecord::Base
  belongs_to :section
  
  has_many :properties
end