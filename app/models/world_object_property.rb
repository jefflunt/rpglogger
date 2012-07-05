class WorldObjectProperty < ActiveRecord::Base
  belongs_to :section_property
  belongs_to :world_object
  
  validate :boolean_properties_cannot_be_nil

  validates :section_property_id, :presence => true
  validates :sort_order, :presence => true
  
  default_scope includes(:section_property).order("section_properties.sort_order ASC")
  
  def sort_order
    section_property.sort_order
  end
  
  def raw_value
    case section_property.data_type
    when 'integer'
      return integer_value
    when 'boolean'
      if boolean_value
        return "\u2714"
      else
        return "\u2716"
      end
    when 'string'
      return string_value
    when 'text'
      return text_value
    end
  end
  
  private 
    def boolean_properties_cannot_be_nil
      if section_property.data_type.eql?("boolean")
        unless !boolean_value.nil?
          errors.add("Boolean properties must have a default value - they cannot be nil.")
        end
      end
    end
  
end