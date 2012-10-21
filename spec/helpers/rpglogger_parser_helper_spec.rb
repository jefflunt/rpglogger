require 'spec_helper'

describe RpgloggerParserHelper do
  helper MarkdownHelper
  # Match on:
  #   [[this text]][123]                    <= The most common, valid form
  #   and [[  this text ]][123]             <= Spaces in the link field are fine, but will be ignored
  #
  #   BUT NOT on any of [ [that]][123]      <= Whitespace between bracks is invalid
  #   nor [[th                              <= Link breaks inside links are invalid
  #   at]][123]                             <=    ...continued
  #   nor [[that][123]                      <= Missing the double bracket on the right
  #   nor [that]][123]                      <= Missing the double bracket on the left
  #   nor [that][123]                       <= Single brackets are reserved for Markdown
  
  before(:each) do
    @world_object = FactoryGirl.create(:world_object, section: FactoryGirl.create(:section))
    WorldObject.stub(:find).and_return(@world_object)
    @valid_links = [
      "[[#{@world_object.name}]][#{@world_object.id}]",
      "[[  #{@world_object.name}]][#{@world_object.id}]",
      "[[#{@world_object.name}  ]][#{@world_object.id}]",
      "[[  #{@world_object.name}    ]][#{@world_object.id}]",
    ]
      
    @invalid_links = [
      "[[ invalid li  nk]][ 12 3]",   # Contains a space inside between the digits of the ID field
      "[[ invali\nd link]][123]",     # Contains a line break
    ] 
  end
  
  it "should strip out extra white space around link text and IDs so long as the link is otherwise valid" do
    with_whitespace = "[[  first link   ]][ 123   ][[       second link ]][      456           ]"
    
    rpglogger_parse(with_whitespace).should == "<p><a href=\"#{section_url(@world_object.section)}##{@world_object.id}\">first link</a><a href=\"#{section_url(@world_object.section)}##{@world_object.id}\">second link</a></p>"
  end
    
  it "should recognize standalone links" do
    @valid_links.each do |link|
      rpglogger_parse(link).should == "<p><a href=\"#{section_url(@world_object.section)}##{@world_object.id}\">#{@world_object.name}</a></p>"
    end
  end
  
  it "should ignore invalid links" do
    # Invalid links should be returned unaltered
    @invalid_links.each do |link|
      rpglogger_parse(link).should == "<p>#{link}</p>"
    end
  end
  
  it "should be able to recognize several standalone links not separated by spaces" do
    multiple_standalone_links = "[[first link]][123][[second link]][456]"
    
    rpglogger_parse(multiple_standalone_links).should == "<p><a href=\"#{section_url(@world_object.section)}##{@world_object.id}\">first link</a><a href=\"#{section_url(@world_object.section)}##{@world_object.id}\">second link</a></p>"
  end
  
  it "should be able to recognize links mingled with other text" do
    links_with_text = "Starting text, [[first link]][123] middle text, [[second link]][456] and final text."
    
    rpglogger_parse(links_with_text).should == "<p>Starting text, <a href=\"#{section_url(@world_object.section)}##{@world_object.id}\">first link</a> middle text, <a href=\"#{section_url(@world_object.section)}##{@world_object.id}\">second link</a> and final text.</p>"
  end
  
  it "should be able to recognize several standalone links on individual lines" do
    links_in_many_lines = "Starting text, [[first link]][123]\n\nmiddle text,\n\n[[second link]][456] and final text."

    rpglogger_parse(links_in_many_lines).should == "<p>Starting text, <a href=\"#{section_url(@world_object.section)}##{@world_object.id}\">first link</a></p>\n\n" + 
                                                   "<p>middle text,</p>\n\n" +
                                                   "<p><a href=\"#{section_url(@world_object.section)}##{@world_object.id}\">second link</a> and final text.</p>"
  end
end