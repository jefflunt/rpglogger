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
  
  it "should redirect from the show action to the first active section in a logbook" do
    log_book = FactoryGirl.create(:log_book, is_public: true)
    FactoryGirl.create(:section, name: "Archived section", log_book_id: log_book.id, archived_at: Time.now)
    FactoryGirl.create(:section, name: "Active section", log_book_id: log_book.id)
    
    active_section = log_book.sections.active.first
    
    visit "/log_books/#{log_book.id}"
    
    URI.parse(current_url).path.should == section_path(active_section)
  end
  
  it "should create an active, empty section from the show action (and then redirect to that section), if no active sections are available in a logbook" do
    log_book = FactoryGirl.create(:log_book, is_public: true)
    log_book.sections.count.should == 0
    
    visit "/log_books/#{log_book.id}"
    new_active_section = log_book.sections.active.first
    URI.parse(current_url).path.should == section_path(new_active_section)
    
    log_book.sections.count.should == 1
    log_book.sections.active.count.should == 1
    log_book.sections.archived.count.should == 0
  end
  
  it "should redirect you to the first active section when you try to access a section that is archived, and display a flash message indicating an issue." do
    log_book = FactoryGirl.create(:log_book, is_public: true)
    FactoryGirl.create(:section, name: "Archived section", log_book_id: log_book.id, archived_at: Time.now)
    FactoryGirl.create(:section, name: "Active section", log_book_id: log_book.id)
    
    active_section = log_book.sections.active.first
    archived_section = log_book.sections.archived.first
    
    visit section_path(archived_section)
    
    URI.parse(current_url).path.should == section_path(active_section)
  end
end