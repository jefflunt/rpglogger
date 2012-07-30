class WorldObjectsController < ApplicationController
  
  def new
    @world_object = WorldObject.new
    section = Section.find(params[:section_id])
    authorize! :new, WorldObject
    
    @log_book = section.log_book
    @world_object.section = section
    @world_object.section.section_properties.each do |sp|
      @world_object.world_object_properties.build(:section_property_id => sp.id)
    end
    
    render 'world_object_form'
  end
  
  def create
    @world_object = WorldObject.new(params[:world_object])
    authorize! :create, WorldObject
    
    if @world_object.save
      redirect_to section_path(@world_object.section), notice: "Created"
    else
      render 'world_object_form'
    end
  end
      
  def edit
    @world_object = WorldObject.find(params[:id])
    authorize! :edit, @world_object
    
    @log_book = @world_object.section.log_book
    render 'world_object_form'
  end
  
  def update
    @world_object = WorldObject.find(params[:id])
    authorize! :update, @world_object
    
    @log_book = @world_object.section.log_book
    if @world_object.update_attributes(params[:world_object])
      redirect_to section_path(@world_object.section), notice: "Updated"
    else
      render 'world_object_form'
    end
  end
  
  def destroy
    @world_object = WorldObject.find(params[:id])
    authorize! :destory, @world_object
    
    @world_object.destroy
    
    redirect_back_or section_path(@world_object.section), notice: "Deleted".html_safe
  end
  
  def archive
    @world_object = WorldObject.find(params[:id])
    authorize! :archive, @world_object
    
    @world_object.update_attribute(:archived_at, Time.now)
    
    redirect_back_or log_book_path(@world_object.section.log_book), notice: "Archived (<a href=\"#{restore_section_world_object_path(@world_object.section.id, @world_object.id)}\" data-method=\"put\">undo</a>)".html_safe
  end
  
  def restore
    @world_object = WorldObject.find(params[:id])
    authorize! :restore, @world_object
    
    @world_object.update_attribute(:archived_at, nil)
    
    redirect_back_or log_book_path(@world_object.section.log_book), notice: "Restored"
  end
  
end