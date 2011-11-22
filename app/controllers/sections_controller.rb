class SectionsController < ApplicationController
  load_and_authorize_resource
  
  def show
    @section.world_objects.sort!{|w1,w2| w1.name.downcase <=> w2.name.downcase}
  end
  
  def edit
  end
  
  def update
    @section.update_attributes(params[:section])
    
    if params[:section_properties][:new_section_property_names]
      highest_existing_sort_order = @section.section_properties.collect{|sp| sp.sort_order}.max || 0
      new_names = params[:section_properties][:new_section_property_names].split(',').collect{|sp| sp.strip}.each_with_index do |new_section_property_name, index|
        SectionProperty.create!(:section_id=>@section.id, :name=>new_section_property_name, :sort_order=>highest_existing_sort_order+index+1, :data_type=>params[:data_type])
      end
    end
    
    redirect_to log_book_path(@section.log_book) + "?section=#{@section.name}"
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