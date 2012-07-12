class SectionPropertiesController < ApplicationController
  def destroy
    section_property = SectionProperty.find(params[:id])
    authorize! :update, section_property.section.log_book
    
    section = section_property.section
    section_property.destroy
    
    redirect_to edit_section_path(section), notice: "Attribute deleted"
  end
end