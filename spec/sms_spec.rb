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
    
    it "should accept a single phone number and a message parameter" do
      api = Clockwork::API.new test_api_key
      message = api.messages.build( :to => '441234123456', :content => 'This is a test message.' )
      response = message.deliver
      
      response.should be_an_instance_of Clockwork::SMS::Response
      response.success.should == true
      response.message_id.should_not be_empty
    end
    
    it "should not send a blank message" do
      api = Clockwork::API.new test_api_key
      message = api.messages.build( :to => '441234123456', :content => '' )
      response = message.deliver
      
      response.should be_an_instance_of Clockwork::SMS::Response
      response.success.should == false
      response.message_id.should be_nil
      response.error_code.should == 7
    end
    
    it "should accept additional parameters" do
      api = Clockwork::API.new test_api_key
      message = api.messages.build( :to => '441234123456', :content => 'This is a test message.', :client_id => 'message123' )
      response = message.deliver
      
      response.should be_an_instance_of Clockwork::SMS::Response
      response.success.should == true
      response.message_id.should_not be_empty
      response.message.client_id.should == 'message123'
    end
    
    it "should allow delivering multiple messages" do
      messages = [
          { :to => '441234123456', :content => 'This is a test message.', :client_id => '1' },
          { :to => '441234123456', :content => 'This is a test message 2.', :client_id => '2' },
          { :to => '441234123456', :content => 'This is a test message 3.', :client_id => '3' },
          { :to => '441234123456', :content => 'This is a test message 4.', :client_id => '4' },
          { :to => '441234123456', :content => 'This is a test message 5.', :client_id => '5' },
          { :to => '441234123456', :content => 'This is a test message 6.', :client_id => '6' },
          { :to => '44', :content => 'This is a test message 6.', :client_id => '7' }
      ]

      api = Clockwork::API.new test_api_key
      messages.each do |m|
        api.messages.build(m)
      end

      responses = api.deliver_messages
      
      responses.count.should == 7
      responses.first.success.should == true
      
      responses.last.success.should == false
      responses.last.error_code.should == 10
    end
    
  end
  
end