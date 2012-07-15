class SectionPropertiesController < ApplicationController
  def destroy
    section_property = SectionProperty.find(params[:id])
    authorize! :update, section_property.section.log_book
    
    section = section_property.section
    section_property.destroy
    
    redirect_back_or edit_section_path(section), notice: "Attribute deleted (<a href=\"#{untrash_section_section_property_path(section_property.id)}\" data-method=\"put\">undo</a>)".html_safe
  end
  
  def untrash
    section_property = SectionProperty.only_deleted.find(params[:id])
    authorize! :update, section_property.section.log_book
    
    section_property.update_attribute(:deleted_at, nil)
    
    redirect_back_or log_books_path, notice: "Attribute restored"
  end
  
end