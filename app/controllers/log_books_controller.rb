class LogBooksController < ApplicationController
  def index
    authorize! :index, LogBook
    
    @public_log_books = LogBook.public
    
    if current_user
      @show_deleted_items = params[:show_deleted]
      @private_log_books = current_user.owned_and_shared_log_books(params[:show_deleted])
    end
  end
  
  def show
    @log_book = LogBook.find(params[:id])
    authorize! :show, @log_book
    
    @log_book.create_empty_section if @log_book.sections.count == 0
        
    redirect_to section_path(@log_book.sections.first)
  end
  
  def new
    @log_book = LogBook.new
    authorize! :new, @log_book
    
    if !current_user
      redirect_to new_sessions_path, notice: "You must be logged in to create a log book"
    else
      @log_book.user_id = current_user.id
    end
  end
  
  def create
    @log_book = LogBook.new(params[:log_book])
    authorize! :create, LogBook
    
    if @log_book.save
      @log_book.create_default_sections
      redirect_to @log_book, notice: "Log book created"
    else
      render 'new'
    end
  end
  
  def edit
    @log_book = LogBook.find(params[:id])
    authorize! :edit, @log_book
    
    if params[:show_deleted]
      @show_deleted_sections = params[:show_deleted]
      @list_of_sections = Section.unscoped.where(["log_book_id = ?", @log_book.id]).order("LOWER(name) ASC")
    else
      @list_of_sections = @log_book.sections.order_by_name
    end
  end
  
  def update
    @log_book = LogBook.find(params[:id])
    authorize! :update, @log_book
    
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
    @log_book = LogBook.find(params[:id])
    authorize! :destroy, @log_book
    
    @log_book.destroy
    
    redirect_back_or log_books_path, notice: "Log book deleted (<a href=\"#{untrash_log_book_path(@log_book.id)}\" data-method=\"put\">undo</a>)".html_safe
  end
  
  # PUT /log_books/:id/untrash
  # Using the `paranoia` gem, this method clears the `deleted_at` field
  def untrash
    @log_book = LogBook.only_deleted.find(params[:id])
    authorize! :untrash, @log_book
    
    @log_book.update_attribute(:deleted_at, nil)
    
    redirect_back_or log_books_path, notice: "Log book restored"
  end
end