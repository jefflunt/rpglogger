class WorldObjectsController < ApplicationController
  
  def show
    @world_object = WorldObject.find(params[:id])
    render 'world_object_form'
  end
  
  def new
    section = Section.find_by_name(params[:section])
    case section.name
    when "character"
      @world_object = Character.new(:section=>section)
    when "location"
      @world_object = Location.new(:section=>section)
    when "journal"
      @world_object = NotesEntry.new(:section=>section)
    when "quest"
      @world_object = Quest.new(:section=>section)
    end
    
    #debugger
    render 'world_object_form'
  end
  
  def create
    world_object = WorldObject.create(params[:world_object])
    
    redirect_to log_book_path(world_object.section.log_book) + "?section=#{world_object.section.name}"
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