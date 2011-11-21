class LogBooksController < ApplicationController
  load_and_authorize_resource
  
  def show
    @log_book.create_default_sections unless @log_book.sections.count > 0
        
    redirect_to section_path(@log_book.sections.first)
  end
  
  
  def new
    if !current_user
      redirect_to '/sessions/new'
    else
      @log_book.user_id = current_user.id
    end
  end
  
  def create
    @log_book = LogBook.new(params[:log_book])
    
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
      flash.keep
      return redirect_to new_sessions_path
    end
  end
  
  def edit
    @log_book = LogBook.find(params[:id])
  end
  
  def update
    @log_book.update_attributes(params[:log_book])
    
    if (params[:sections])
      new_names = params[:sections][:new_names].split(', ').collect{|s| s.strip}.each do |new_name|
        Section.create!(:name=>new_name, :log_book_id=>@log_book.id)
      end
    end
    
    redirect_to edit_log_book_path(@log_book)
  end
    
end