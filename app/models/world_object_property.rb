class WorldObjectProperty < ActiveRecord::Base
  belongs_to :section_property
  belongs_to :world_object
  
  validate :boolean_properties_cannot_be_nil
  
  def raw_value
    case section_property.data_type
    when 'integer'
      return integer_value
    when 'boolean'
      if boolean_value
        return "✓"
      else
        return "NO"
      end
    when 'string'
      return string_value
    when 'text'
      return text_value
    end
  end
  
  def correct_form_field(form)
    case section_property.data_type
    when 'integer'
      return form.text_field  :integer_value
    when 'boolean'
      return form.check_box   :boolean_value
    when 'string'
      return form.text_field  :string_value
    when 'text'
      return form.text_area   :text_value
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