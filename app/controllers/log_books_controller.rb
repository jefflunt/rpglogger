class LogBooksController < ApplicationController
  load_and_authorize_resource
  
  def index
    @public_log_books = LogBook.public
    
    if current_user
      return @log_books = LogBook.find(:all, :conditions => "user_id = #{current_user.id}", :order => 'title ASC')
    else
      flash.keep
    end
  end
  
  def show
    @log_book.create_empty_section if @log_book.sections.count == 0
        
    redirect_to section_path(@log_book.sections.first)
  end
  
  def new
    if !current_user
      redirect_to new_sessions_path, notice: "You must be logged in to create a log book"
    else
      @log_book.user_id = current_user.id
    end
  end
  
  def create
    if @log_book.save
      @log_book.create_default_sections
      redirect_to @log_book, notice: "Log book created"
    else
      render 'new'
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
    
    redirect_to edit_log_book_path(@log_book), notice: "Log book updated"
  end
  
  def destroy
    @log_book.destroy
    
    redirect_back_or log_books_path, notice: "Log book deleted"
  end
    
end