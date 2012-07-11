class WorldObjectsController < ApplicationController
  def new
    @world_object = WorldObject.new
    section = Section.find(params[:section_id])
    authorize! :update, section.log_book
    
    @log_book = section.log_book
    @world_object.section = section
    @world_object.section.section_properties.each do |sp|
      @world_object.world_object_properties.build(:section_property_id => sp.id)
    end
    
    render 'world_object_form'
  end
  
  def create
    @world_object = WorldObject.new(params[:world_object])
    authorize! :update, @world_object.section.log_book
    
    if @world_object.save
      redirect_to section_path(@world_object.section), notice: "Created"
    else
      render 'world_object_form'
    end
  end
      
  def edit
    @world_object = WorldObject.find(params[:id])
    authorize! :update, @world_object.section.log_book
    
    @log_book = @world_object.section.log_book
    render 'world_object_form'
  end
  
  def update
    @world_object = WorldObject.find(params[:id])
    authorize! :update, @world_object.section.log_book
    
    @log_book = @world_object.section.log_book
    if @world_object.update_attributes(params[:world_object])
      redirect_to section_path(@world_object.section), notice: "Updated"
    else
      render 'world_object_form'
    end
  end
  
  def destroy
    @world_object = WorldObject.find(params[:id])
    authorize! :update, @world_object.section.log_book
    
    @world_object.destroy
    
    redirect_to section_path(@world_object.section), notice: "Deleted"
  end
  
end