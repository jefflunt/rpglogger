class LogBooksController < ApplicationController
  
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