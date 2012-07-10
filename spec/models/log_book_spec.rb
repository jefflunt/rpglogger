require 'spec_helper'

describe LogBook do
  before(:each) do
    @log_book = FactoryGirl.create(:log_book)
  end
  
  it "cannot have its `public` attribute changed via mass assignment" do
    @log_book.is_public.should be false
    @log_book.title.should_not == "New title"
    params = {log_book: {title: "New title", public: true}}
    
    @log_book.update_attributes(params[:log_book])
    @log_book.reload
    
    @log_book.title.should == "New title"
    @log_book.public?.should be false
  end
end