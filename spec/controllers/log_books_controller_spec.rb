require 'spec_helper'

describe LogBooksController do
  before(:each) do
    @game = Factory.create(:game)
    @user = Factory.create(:user)
  end
  
  it "should create the default sections when a new LogBook is created" do
    LogBook.count.should == 0
    Section.count.should == 0
    
    post :create, :log_book => {:title=>'My new LogBook', :game_id=>@game.id, :user_id=>@user.id}
    new_log_book = LogBook.last
    #response.should redirect_to(log_book_path(new_log_book))
    
    LogBook.count.should == 1
    Section.count.should == 4
  end
  
  it "should create an empty section upon showing itself, if none currently exists" do
    fail
  end
  
end