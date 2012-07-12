require 'spec_helper'

describe Ability do
  before(:each) do
    @anonymous_user = User.new
    @editor_user = FactoryGirl.create(:user, provider: "rpglogger-auth", uid: "1234", name: "testing user", nickname: "testing_user")
    @owner_user =  FactoryGirl.create(:user, provider: "rpglogger-auth", uid: "5678", name: "owning user", nickname: "owning_user")
    
    @public_log_book = FactoryGirl.create(:log_book, title: "Public LogBook", is_public: true, user_id: @owner_user.id)
    FactoryGirl.create(:section, name: "Public Section", log_book_id: @public_log_book.id)
    FactoryGirl.create(:section_property, name: "Public Section Property", section_id: @public_log_book.sections.first.id)
    FactoryGirl.create(:world_object, name: "Public WorldObject", section_id: @public_log_book.sections.first.id)
    
    @editor_access_log_book = FactoryGirl.create(:log_book, title: "Editor access LogBook", is_public: false, user_id: @owner_user.id)
    FactoryGirl.create(:share, log_book_id: @editor_access_log_book.id, user_id: @editor_user.id, role: "editor")
    FactoryGirl.create(:section, name: "Editor access Section", log_book_id: @editor_access_log_book.id)
    FactoryGirl.create(:section_property, name: "Editor access Section Property", section_id: @editor_access_log_book.sections.first.id)
    FactoryGirl.create(:world_object, name: "Editor access WorldObject", section_id: @editor_access_log_book.sections.first.id)
    
    @private_log_book = FactoryGirl.create(:log_book, title: "Private LogBook", is_public: false, user_id: @owner_user.id)
    FactoryGirl.create(:section, name: "Private Section", log_book_id: @private_log_book.id)
    FactoryGirl.create(:section_property, name: "Private Section Property", section_id: @private_log_book.sections.first.id)
    FactoryGirl.create(:world_object, name: "Private WorldObject", section_id: @private_log_book.sections.first.id)
  end
  
  it "authorizes all users (anonymous and registered) to get to the LogBooks index action" do
    Ability.new(@owner_user).can?(:index, LogBook).should be true
    
    Ability.new(@editor_user).can?(:index, LogBook).should be true
    
    Ability.new(@anonymous_user).can?(:index, LogBook).should be true
  end
  
  it "denies anonymous users the ability to access the `new` and `create` LogBook actions. Registered users may access these actions." do
    Ability.new(@owner_user).can?(:new, LogBook).should be true
    Ability.new(@owner_user).can?(:create, LogBook).should be true
    
    Ability.new(@editor_user).can?(:new, LogBook).should be true
    Ability.new(@editor_user).can?(:create, LogBook).should be true
    
    Ability.new(@anonymous_user).can?(:new, LogBook).should be false
    Ability.new(@anonymous_user).can?(:create, LogBook).should be false
  end
  
  it "authorizes anonymous users to view public LogBooks, editors to view LogBooks to which they have the 'editor` role, and owners to view their own log books." do
    Ability.new(@owner_user).can?(:show, @public_log_book).should be true
    Ability.new(@owner_user).can?(:show, @editor_access_log_book).should be true
    Ability.new(@owner_user).can?(:show, @private_log_book).should be true
    
    Ability.new(@editor_user).can?(:show, @public_log_book).should be true
    Ability.new(@editor_user).can?(:show, @editor_access_log_book).should be true
    Ability.new(@editor_user).can?(:show, @private_log_book).should be false
    
    Ability.new(@anonymous_user).can?(:show, @public_log_book).should be true
    Ability.new(@anonymous_user).can?(:show, @editor_access_log_book).should be false
    Ability.new(@anonymous_user).can?(:show, @private_log_book).should be false
  end
  
  it "only allows a LogBook's owner to destroy said LogBook" do
    Ability.new(@owner_user).can?(:destroy, @public_log_book).should be true
    Ability.new(@owner_user).can?(:destroy, @editor_access_log_book).should be true
    Ability.new(@owner_user).can?(:destroy, @private_log_book).should be true
    
    Ability.new(@editor_user).can?(:destroy, @public_log_book).should be false
    Ability.new(@editor_user).can?(:destroy, @editor_access_log_book).should be false
    Ability.new(@editor_user).can?(:destroy, @private_log_book).should be false
    
    Ability.new(@anonymous_user).can?(:destroy, @public_log_book).should be false
    Ability.new(@anonymous_user).can?(:destroy, @editor_access_log_book).should be false
    Ability.new(@anonymous_user).can?(:destroy, @private_log_book).should be false
  end
  
  it "only allows a LogBook's owner to edit and update the LogBook (which includes Sections and their names, as well as user roles)" do
    Ability.new(@owner_user).can?(:edit, @public_log_book).should be true                 # owner
    Ability.new(@owner_user).can?(:edit, @editor_access_log_book).should be true          # owner
    Ability.new(@owner_user).can?(:edit, @private_log_book).should be true                # owner
    
    Ability.new(@owner_user).can?(:update, @public_log_book).should be true               # owner
    Ability.new(@owner_user).can?(:update, @editor_access_log_book).should be true        # owner
    Ability.new(@owner_user).can?(:update, @private_log_book).should be true              # owner
    
    Ability.new(@editor_user).can?(:edit, @public_log_book).should be false               # public
    Ability.new(@editor_user).can?(:edit, @editor_access_log_book).should be false        # editor
    Ability.new(@editor_user).can?(:edit, @private_log_book).should be false              # no access
    
    Ability.new(@editor_user).can?(:update, @public_log_book).should be false             # public
    Ability.new(@editor_user).can?(:update, @editor_access_log_book).should be false      # editor
    Ability.new(@editor_user).can?(:update, @private_log_book).should be false            # no access
    
    Ability.new(@anonymous_user).can?(:edit, @public_log_book).should be false            # public
    Ability.new(@anonymous_user).can?(:edit, @editor_access_log_book).should be false     # no access
    Ability.new(@anonymous_user).can?(:edit, @private_log_book).should be false           # no access
    
    Ability.new(@anonymous_user).can?(:update, @public_log_book).should be false          # public
    Ability.new(@anonymous_user).can?(:update, @editor_access_log_book).should be false   # no access
    Ability.new(@anonymous_user).can?(:update, @private_log_book).should be false         # no access
  end
  
  
  it "only allows a LogBook's owner to delete Sections and SectionProperties" do
    Ability.new(@owner_user).can?(:destroy, @public_log_book.sections.first).should be true                                   # owner
    Ability.new(@owner_user).can?(:destroy, @editor_access_log_book.sections.first).should be true                            # owner
    Ability.new(@owner_user).can?(:destroy, @private_log_book.sections.first).should be true                                  # owner
    
    Ability.new(@owner_user).can?(:destroy, @public_log_book.sections.first.section_properties.first).should be true                # owner
    Ability.new(@owner_user).can?(:destroy, @editor_access_log_book.sections.first.section_properties.first).should be true         # owner
    Ability.new(@owner_user).can?(:destroy, @private_log_book.sections.first.section_properties.first).should be true               # owner
    
    Ability.new(@editor_user).can?(:destroy, @public_log_book.sections.first).should be false                                 # public
    Ability.new(@editor_user).can?(:destroy, @editor_access_log_book.sections.first).should be false                          # editor
    Ability.new(@editor_user).can?(:destroy, @private_log_book.sections.first).should be false                                # no accesss
    
    Ability.new(@editor_user).can?(:destroy, @public_log_book.sections.first.section_properties.first).should be false              # public
    Ability.new(@editor_user).can?(:destroy, @editor_access_log_book.sections.first.section_properties.first).should be false       # editor
    Ability.new(@editor_user).can?(:destroy, @private_log_book.sections.first.section_properties.first).should be false             # no-access
    
    Ability.new(@anonymous_user).can?(:destroy, @public_log_book).should be false                                             # public
    Ability.new(@anonymous_user).can?(:destroy, @editor_access_log_book).should be false                                      # no access
    Ability.new(@anonymous_user).can?(:destroy, @private_log_book).should be false                                            # no access
    
    Ability.new(@anonymous_user).can?(:destroy, @public_log_book.sections.first.section_properties.first).should be false           # public
    Ability.new(@anonymous_user).can?(:destroy, @editor_access_log_book.sections.first.section_properties.first).should be false    # no access
    Ability.new(@anonymous_user).can?(:destroy, @private_log_book.sections.first.section_properties.first).should be false          # no access
  end
  
  it "authorizes owners and editors to edit WorldObjects, but not anonymous users."
  
end