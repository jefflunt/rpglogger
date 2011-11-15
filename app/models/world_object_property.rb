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
    when 'datetime'
      return form.text_field  :datetime_value
    end
  end
end