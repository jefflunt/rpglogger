class SectionPropertiesController < ApplicationController
  def create
    @section = Section.find(params[:section_id])
    
    authorize! :update, @section.log_book
    
    next_sort_order = @section.section_properties.count == 0 ? 1 : @section.section_properties.collect{|sp| sp.sort_order}.max + 1
    
    create_new_section_properties_from(params[:new_properties][:names], params[:data_type], next_sort_order)
    
    redirect_to edit_section_path(@section.id), notice: "Attribute added"
  end
  
  def destroy
    section_property = SectionProperty.find(params[:id])
    authorize! :update, section_property.section.log_book
    
    section = section_property.section
    section_property.destroy
    
    redirect_to edit_section_path(section), notice: "Attribute deleted"
  end
  
  private
    def create_new_section_properties_from(comma_separated_list_of_names, data_type, next_sort_order)
      new_section_names = comma_separated_list_of_names.split(',').collect{|s| s.strip}.each_with_index do |name, index|
        new_section_property = SectionProperty.create(:name=>name, :data_type=>data_type, :sort_order=>next_sort_order+index, :section_id=>@section.id) unless name.empty? || name.blank?
        
        @section.world_objects.each do |wo|
          WorldObjectProperty.create(
            :section_property=>new_section_property,
            :world_object=>wo,
            :boolean_value=>false
          )
        end
      end
    end
  
end