class LogBooksController < ApplicationController
  load_and_authorize_resource
  
  def new
    if !current_user
      redirect_to '/sessions/new'
    else
      @log_book = LogBook.new(:user_id => current_user.id)
    end
  end
  
  def create
    @log_book = LogBook.new(params[:log_book]) do |log_book|
      log_book.game_id = Game.find_by_name(params[:game][:name])
    end
    
    if @log_book.save
      @log_book.create_default_sections
      redirect_to log_books_path
    else
      render 'new'
    end
  end
  
  def index
    if current_user
      return @log_books = LogBook.find(:all, :conditions => "user_id = #{current_user.id}", :order => 'title ASC')
    else
      return redirect_to new_sessions_path
    end
  end
  
  def edit
    @log_book = LogBook.find(params[:id])
  end
  
  def update
    log_book = LogBook.find(params[:id])
    log_book.update_attributes(params[:log_book])
    
    redirect_to log_book
  end
  
  def show
    @section = params[:section].nil? ? @log_book.sections.first : @log_book.sections.find_by_name(params[:section])
    @world_objects = WorldObject.find(:all, :conditions => "section_id = #{@section.id}", :order => 'name ASC')
#    @world_objects.count == 0 ? @world_objects = [WorldObject.new(:name=>"--------")]
    
    if @log_book.sections.count == 0
      @log_book.create_default_sections
      redirect_to log_book_path(@log_book)
    end
  end
  
end