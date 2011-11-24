require 'spec_helper'

describe LogBooksController do
  it "should redirect to the log_books_controller#new action when a user logs in who owns zero LogBooks" do    
    visit '/auth/facebook'
    
    response.should redirect_to new_log_book_path
  end
  
  it "should redirect to the log_books_controller#index action when a user logs in who owns one or more LogBooks" do
    fooman = Factory.create(:user, :provider=>'facebook', :uid=>'1234', :name=>'Foo Man', :nickname=>'fooman')
    Factory.create(:log_book, :user_id=>fooman.id)
    
    User.count.should == 1
    LogBook.count.should == 1
    
    visit '/auth/facebook'
    
    response.should redirect_to log_books_path
  end
end