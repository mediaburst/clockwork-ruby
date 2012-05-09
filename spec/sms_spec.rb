require File.join( File.dirname(__FILE__) + "/spec_helper" )

describe "SMS" do
  
  let(:test_api_key) { IO.read( File.join( File.dirname(__FILE__) + "/spec_authentication_details" ) ).split("\n")[0] }
  
  describe "#initialize" do

    it "should set options if a parameters hash is passed" do
      sms = Clockwork::SMS.new( :from => 'A Test', :long => true, :truncate => true, :invalid_char_action => :remove )
      sms.from.should == "A Test"
      sms.long.should == true
      sms.truncate.should == true
      sms.invalid_char_action.should == :remove
    end

  end
  
  describe "#deliver" do
    
    # it "should accept a single phone number and a message parameter" do
    #   api = Clockwork::API.new test_api_key
    #   result = api.send_message '441234123456', 'This is a test.'
    #   result.should be_an_instance_of Clockwork::SMS::Response
    #   result.success.should == true
    #   result.message_id.should_not be_empty
    # end
    
    # it "should accept an array of phone numbers and a message parameter" do
    #   api = Clockwork::API.new test_api_key
    #   results = api.send_message ['441234123456', '441234654321'], 'This is a test.'
    #   
    # end
    # 
    # it "should accept additional options"
    # 
    # it "should not send a blank message" do
    #   api = Clockwork::API.new test_api_key
    #   result = api.send_message '441234123456', ''
    #   result.should be_an_instance_of Clockwork::SMS::Response
    #   result.success.should == false
    #   result.message_id.should be_nil
    #   result.error_code.should == 7
    # end
  
  end
  
end