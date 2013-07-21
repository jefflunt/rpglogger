class LogBooksController < ApplicationController
  def index
    authorize! :index, LogBook
    
    HowSlow::Collector::count("views.homepage")

    @public_log_books = LogBook.active.public.order_by_title
    
    if current_user
      @show_archived_items = params[:show_archived]
      @private_log_books = current_user.owned_and_shared_log_books(params[:show_archived])
    end
  end
  
  def show
    @log_book = LogBook.find(params[:id])
    authorize! :show, @log_book
    
    @log_book.create_empty_section if @log_book.sections.active.count == 0
        
    redirect_to section_path(@log_book.sections.active.order_by_name.first)
  end
  
  def new
    @log_book = LogBook.new
    authorize! :new, @log_book
    
    if !current_user
      redirect_to new_sessions_path, notice: "You must be logged in to create a logbook"
    else
      @log_book.user_id = current_user.id
    end
  end
  
  def create
    @log_book = LogBook.new(params[:log_book])
    authorize! :create, LogBook
    
    if @log_book.save
      @log_book.create_default_sections
      redirect_to @log_book, notice: "Logbook created"
    else
      render 'new'
    end
  end
  
  def edit
    @log_book = LogBook.find(params[:id])
    authorize! :edit, @log_book
    
    if params[:show_archived]
      @show_archived_sections = params[:show_archived]
      @list_of_sections = @log_book.sections.order_by_name
    else
      @list_of_sections = Section.active.where(["log_book_id = ?", @log_book.id]).order("LOWER(name) ASC")
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
    
    redirect_to edit_log_book_path(@log_book), notice: "Logbook updated"
  end
  
  def destroy
    @log_book = LogBook.find(params[:id])
    authorize! :destroy, @log_book
    
    @log_book.destroy
    
    redirect_back_or log_books_path, notice: "Logbook deleted".html_safe
  end
  
  def archive
    @log_book = LogBook.find(params[:id])
    authorize! :archive, @log_book
    
    @log_book.update_attribute(:archived_at, Time.now)
    
    redirect_back_or log_books_path, notice: "Logbook archived (<a href=\"#{restore_log_book_path(@log_book.id)}\" data-method=\"put\">undo</a>)".html_safe
  end
  
  def restore
    @log_book = LogBook.find(params[:id])
    authorize! :restore, @log_book
    
    @log_book.update_attribute(:archived_at, nil)
    
    redirect_back_or log_books_path, notice: "Logbook restored"
  end
end
