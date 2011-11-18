class LogBooksController < ApplicationController
  
  def new
    @log_book = LogBook.new(:user_id => current_user.id)
  end
  
  def create
    new_log_book = LogBook.create!(params[:log_book]) do |log_book|
      log_book.game_id = Game.find_by_name(params[:game][:name])
    end
    
    redirect_to log_books_path
  end
  
  def index
    @log_books = LogBook.all
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
    @log_book = LogBook.find(params[:id])
    @section = params[:section].nil? ? @log_book.sections.first : @log_book.sections.find_by_name(params[:section])
  end
  
end