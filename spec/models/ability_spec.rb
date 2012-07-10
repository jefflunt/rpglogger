require 'spec_helper'

describe Ability do
  before(:each) do
    @anonymous_user = User.new
    @testing_user = FactoryGirl.create(:user, provider: "rpglogger-auth", uid: "1234", name: "testing user", nickname: "testing_user")
    @owning_user =  FactoryGirl.create(:user, provider: "rpglogger-auth", uid: "5678", name: "owning user", nickname: "owning_user")
    @public_log_book = FactoryGirl.create(:log_book, title: "Public LogBook", is_public: true, user_id: @owning_user.id)
    @read_only_log_book = FactoryGirl.create(:log_book, title: "Read-only LogBook", is_public: false, user_id: @owning_user.id)
    @read_write_log_book = FactoryGirl.create(:log_book, title: "Read-write LogBook", is_public: false, user_id: @owning_user.id)
    
    FactoryGirl.create(:share, log_book_id: @read_only_log_book.id, user_id: @testing_user.id, access_level: "read-only")
    FactoryGirl.create(:share, log_book_id: @read_write_log_book.id, user_id: @testing_user.id, access_level: "read-write")
  end
  
  it "authorizes all users (anonymous and registered) to get to the LogBooks index action" do
    Ability.new(@owning_user).can?(:index, LogBook).should be true
    
    Ability.new(@testing_user).can?(:index, LogBook).should be true
    
    Ability.new(@anonymous_user).can?(:index, LogBook).should be true
  end
  
  it "denies anonymous users the ability to access the `new` and `create` LogBook actions. Registered users may access these actions." do
    Ability.new(@owning_user).can?(:new, LogBook).should be true
    Ability.new(@owning_user).can?(:create, LogBook).should be true
    
    Ability.new(@testing_user).can?(:new, LogBook).should be true
    Ability.new(@testing_user).can?(:create, LogBook).should be true
    
    Ability.new(@anonymous_user).can?(:new, LogBook).should be false
    Ability.new(@anonymous_user).can?(:create, LogBook).should be false
  end
  
  it "authorizes all users (anonymous and registered) to read public LogBooks. Registered users read read 'owned', 'read-only', and 'read-write' access LogBooks" do
    Ability.new(@owning_user).can?(:show, @public_log_book).should be true
    Ability.new(@owning_user).can?(:show, @read_only_log_book).should be true
    Ability.new(@owning_user).can?(:show, @read_write_log_book).should be true
    
    Ability.new(@testing_user).can?(:show, @public_log_book).should be true
    Ability.new(@testing_user).can?(:show, @read_only_log_book).should be true
    Ability.new(@testing_user).can?(:show, @read_write_log_book).should be true
    
    Ability.new(@anonymous_user).can?(:show, @public_log_book).should be true
    Ability.new(@anonymous_user).can?(:show, @read_only_log_book).should be false
    Ability.new(@anonymous_user).can?(:show, @read_write_log_book).should be false
  end
  
  it "only allows a LogBook's owner to destroy said LogBook" do
    Ability.new(@owning_user).can?(:destroy, @public_log_book).should be true
    Ability.new(@owning_user).can?(:destroy, @read_only_log_book).should be true
    Ability.new(@owning_user).can?(:destroy, @read_write_log_book).should be true
    
    Ability.new(@testing_user).can?(:destroy, @public_log_book).should be false
    Ability.new(@testing_user).can?(:destroy, @read_only_log_book).should be false
    Ability.new(@testing_user).can?(:destroy, @read_write_log_book).should be false
    
    Ability.new(@anonymous_user).can?(:destroy, @public_log_book).should be false
    Ability.new(@anonymous_user).can?(:destroy, @read_only_log_book).should be false
    Ability.new(@anonymous_user).can?(:destroy, @read_write_log_book).should be false
  end
  
  it "authorizes owners and registered users to edit and update LogBooks to which they have read-write access. Anonymous users are blocked from editing and updating." do
    Ability.new(@owning_user).can?(:edit, @public_log_book).should be true            # owner
    Ability.new(@owning_user).can?(:edit, @read_only_log_book).should be true         # owner
    Ability.new(@owning_user).can?(:edit, @read_write_log_book).should be true        # owner
    
    Ability.new(@owning_user).can?(:update, @public_log_book).should be true          # owner
    Ability.new(@owning_user).can?(:update, @read_only_log_book).should be true       # owner
    Ability.new(@owning_user).can?(:update, @read_write_log_book).should be true      # owner
    
    Ability.new(@testing_user).can?(:edit, @public_log_book).should be false          # read-only
    Ability.new(@testing_user).can?(:edit, @read_only_log_book).should be false       # read-only
    Ability.new(@testing_user).can?(:edit, @read_write_log_book).should be true       # read-write
    
    Ability.new(@testing_user).can?(:update, @public_log_book).should be false        # read-only
    Ability.new(@testing_user).can?(:update, @read_only_log_book).should be false     # read-only
    Ability.new(@testing_user).can?(:update, @read_write_log_book).should be true     # read-write
    
    Ability.new(@anonymous_user).can?(:edit, @public_log_book).should be false        # read-only  
    Ability.new(@anonymous_user).can?(:edit, @read_only_log_book).should be false     # no access, not shared to this user
    Ability.new(@anonymous_user).can?(:edit, @read_write_log_book).should be false    # no access, not shared to this user
    
    Ability.new(@anonymous_user).can?(:update, @public_log_book).should be false      # read-only
    Ability.new(@anonymous_user).can?(:update, @read_only_log_book).should be false   # no access, not shared to this user
    Ability.new(@anonymous_user).can?(:update, @read_write_log_book).should be false  # no access, not shared to this user
  end
  
end