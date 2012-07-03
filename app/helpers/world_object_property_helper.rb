module WorldObjectPropertyHelper
  def auto_field_for(form, world_object_property)
    case world_object_property.section_property.data_type
    when 'integer'
      return form.text_field  :integer_value
    when 'boolean'
      return form.check_box   :boolean_value, :class=>'center'
    when 'string'
      return form.text_field  :string_value
    when 'text'
      return form.text_area   :text_value
    end
  end
end
