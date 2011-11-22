class WorldObjectsController < ApplicationController
  load_and_authorize_resource
  
  def new
    section = Section.find(params[:section_id])
    @log_book = section.log_book
    @world_object.section = section
    @world_object.section.section_properties.each do |sp|
      @world_object.world_object_properties.build(:section_property_id => sp.id)
    end
    
    render 'world_object_form'
  end
  
  def create    
    if @world_object.save
      redirect_to log_book_path(@world_object.section.log_book) + "?section=#{@world_object.section.name}"
    else
      render 'world_object_form'
    end
  end
      
  def edit
    @log_book = @world_object.section.log_book
    render 'world_object_form'
  end
  
  def update
    @log_book = @world_object.section.log_book
    if @world_object.update_attributes(params[:world_object])
      redirect_to section_path(@world_object.section)
    else
      render 'world_object_form'
    end
  end
  
  def destroy
    world_object = WorldObject.find(params[:id])
    world_object.destroy
    
    redirect_to log_book_path(world_object.section.log_book) + "?section=#{world_object.section.name}"
  end
  
end