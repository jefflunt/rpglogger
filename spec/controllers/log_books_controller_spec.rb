require 'spec_helper'

describe LogBooksController do
  it "should redirect to the log_books_controller#new action when a user logs in who owns zero LogBooks" do    
    visit '/auth/facebook'
    
    URI.parse(current_url).path.should == new_log_book_path
  end
  
  it "should redirect to the log_books_controller#index action when a user logs in who owns one or more LogBooks" do
    facebook_user = FactoryGirl.create(:user, :provider=>'facebook', :uid=>'1234', :name=>'facebook_user', :nickname=>'facebook_user')
    FactoryGirl.create(:log_book, :user_id=>facebook_user.id)
    
    User.count.should == 1
    LogBook.count.should == 1
    
    visit '/auth/facebook'
    
    URI.parse(current_url).path.should == log_books_path
  end
end