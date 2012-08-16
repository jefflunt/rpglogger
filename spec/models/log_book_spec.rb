require 'spec_helper'

describe LogBook do
  before(:each) do
    @log_book = FactoryGirl.create(:section).log_book
  end
  
  it "should be able to tell you if it has any active sections" do
    @log_book.has_active_sections.should be true
    
    @log_book.sections.each{|s| s.update_attribute(:archived_at, Time.now)}
    
    @log_book.reload
    @log_book.does_not_have_active_sections.should be true
  end
end