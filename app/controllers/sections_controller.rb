class SectionsController < ApplicationController
  load_and_authorize_resource
  
  def edit
    @section = Section.find(params[:id])
  end
  
  def update
    section = Section.find(params[:id])
    section.update_attributes(params[:section])
    
    redirect_to log_book_path(section.log_book) + "?section=#{section.name}"
  end
  
  def destroy
    log_book = @section.log_book
    @section.destroy
    
    redirect_to edit_log_book_path(log_book)
  end
  
  private
    def create_new_sections_from(comma_separated_list_of_names)
      new_section_names = comma_separated_list_of_names.split(',').collect{|s| s.strip}.each do |name|
        Section.create(:name=>name, :log_book_id=>@log_book.id) unless name.empty? || name.blank?
      end
    end
  
end