class SectionsController < ApplicationController
  
  def create
    @log_book = LogBook.find(params[:log_book_id])
    
    create_new_sections_from(params[:new_sections][:names])
    
    redirect_to edit_log_book_path(@log_book.id)
  end
  
  def destroy
    section = Section.find(params[:id])
    log_book = section.log_book
    section.destroy
    
    redirect_to edit_log_book_path(log_book)
  end
  
  private
    def create_new_sections_from(comma_separated_list_of_names)
      new_section_names = comma_separated_list_of_names.split(',').collect{|s| s.downcase.strip}.each do |name|
        Section.create(:name=>name, :log_book_id=>@log_book.id) unless name.empty? || name.blank?
      end
    end
  
end