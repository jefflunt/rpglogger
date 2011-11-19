class WorldObjectsController < ApplicationController
  
  def show
    @world_object = WorldObject.find(params[:id])
    render 'world_object_form'
  end
  
  def new
    model_section = Section.find_by_name(params[:section])
    @world_object = WorldObject.new(:section => model_section)
    model_section.section_properties.each do |sp|
      @world_object.world_object_properties.build(:section_property_id => sp.id)
    end
    
    render 'world_object_form'
  end
  
  def create
    @world_object = WorldObject.new(params[:world_object])
    
    if @world_object.save
      redirect_to log_book_path(@world_object.section.log_book) + "?section=#{@world_object.section.name}"
    else
      render 'world_object_form'
    end
  end
  
  def edit
    @world_object = WorldObject.find(params[:id])
    render 'world_object_form'
  end
  
  def update
    world_object = WorldObject.find(params[:id])
    world_object.update_attributes!(params[world_object.class.name.underscore.to_sym])
    
    redirect_to log_book_path(world_object.section.log_book) + "?section=#{world_object.section.name}"
  end
  
  def destroy
    world_object = WorldObject.find(params[:id])
    world_object.destroy
    
    redirect_to log_book_path(world_object.section.log_book) + "?section=#{world_object.section.name}"
  end
  
end