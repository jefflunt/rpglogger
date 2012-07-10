class LogBooksController < ApplicationController
  load_and_authorize_resource
  
  def index
    @public_log_books = LogBook.public
    
    if current_user
      @owned_and_shared_log_books = current_user.owned_and_shared_log_books
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
    
    if (params[:shares])
      params[:shares][:new_google_user].delete    if params[:shares][:new_google_user].blank?
      params[:shares][:new_facebook_user].delete  if params[:shares][:new_facebook_user].blank?
      params[:shares][:new_twitter_user].delete   if params[:shares][:new_twitter_user].blank?
      
      @new_google_user    = User.find_by_nickname_and_provider(params[:shares][:new_google_user],   "google_oauth2")
      @new_facebook_user  = User.find_by_nickname_and_provider(params[:shares][:new_facebook_user], "facebook")
      @new_twitter_user   = User.find_by_nickname_and_provider(params[:shares][:new_twitter_user],  "twitter")
      
      @log_book.shared_users << @new_google_user unless @new_google_user.nil? || @log_book.shared_users.include?(@new_google_user)
      @log_book.shared_users << @new_facebook_user unless @new_facebook_user.nil? || @log_book.shared_users.include?(@new_facebook_user)
      @log_book.shared_users << @new_twitter_user unless @new_twitter_user.nil? || @log_book.shared_users.include?(@new_twitter_user)
    end
    
    if (params[:remove_shared_user_id])
      @log_book.shared_users.delete(User.find(params[:remove_shared_user_id]))
    end
    
    redirect_to edit_log_book_path(@log_book), notice: "Log book updated"
  end
  
  def destroy
    @log_book.destroy
    
    redirect_back_or log_books_path, notice: "Log book deleted"
  end
    
end