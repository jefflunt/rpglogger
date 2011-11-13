class LogBooksController < ApplicationController
  
  def index
    @log_books = LogBook.all
  end
  
end