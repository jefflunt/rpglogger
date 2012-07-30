class SectionPropertiesController < ApplicationController
  def destroy
    section_property = SectionProperty.find(params[:id])
    authorize! :update, section_property.section.log_book
    
    section = section_property.section
    section_property.destroy
    
    redirect_back_or edit_section_path(section), notice: "Attribute deleted".html_safe
  end
  
  def archive
    section_property = SectionProperty.find(params[:id])
    authorize! :archive, section_property.section.log_book
    
    section_property.update_attribute(:archived_at, Time.now)
    
    redirect_back_or log_books_path, notice: "Attribute archived (<a href=\"#{restore_section_section_property_path(section_property.id)}\" data-method=\"put\">undo</a>)".html_safe
  end
  
  def restore
    section_property = SectionProperty.find(params[:id])
    authorize! :restore, section_property.section.log_book
    
    section_property.update_attribute(:archived_at, nil)
    
    redirect_back_or log_books_path, notice: "Attribute restored"
  end
  
end