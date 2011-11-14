class LogBooksController < ApplicationController
  
  def index
    @log_books = LogBook.all
  end
  
  def show
    @log_book = LogBook.find(params[:id])
    @section = params[:section].nil? ? @log_book.sections.first : @log_book.sections.find_by_name(params[:section])
  end
  
end