class WorldObjectProperty < ActiveRecord::Base
  belongs_to :section_property
  belongs_to :world_object
  
  def raw_value
    case section_property.data_type
    when 'integer'
      return integer_value
    when 'boolean'
      return boolean_value
    when 'string'
      return string_value
    when 'text'
      return text_value
    when 'datetime'
      return datetime_value
    end  
  end
end