require File.join( File.dirname(__FILE__) + "/spec_helper" )

describe "SMS" do
  
  let(:test_api_key) { IO.read( File.join( File.dirname(__FILE__) + "/spec_authentication_details" ) ).split("\n")[0] }
  
  describe "#initialize" do

    it "should set options if a parameters hash is passed" do
      sms = Clockwork::SMS.new( :from => 'A Test', :long => true, :truncate => true, :invalid_char_action => :remove )
      expect(sms.from).to match("A Test")
      expect(sms.long).to be(true)
      expect(sms.truncate).to be(true)
      expect(sms.invalid_char_action).to be(:remove)
    end

  end
  
  describe "#deliver" do
    
    it "should accept a single phone number and a message parameter" do
      api = Clockwork::API.new test_api_key
      message = api.messages.build( :to => '441234123456', :content => 'This is a test message.' )
      response = message.deliver
      
      expect(response).to be_an_instance_of Clockwork::SMS::Response
      expect(response.success).to be(true)
      expect(response.message_id).not_to be_empty
    end
    
    it "should not send a blank message" do
      api = Clockwork::API.new test_api_key
      message = api.messages.build( :to => '441234123456', :content => '' )
      response = message.deliver
      
      expect(response).to be_an_instance_of Clockwork::SMS::Response
      expect(response.success).to be(false)
      expect(response.message_id).to be_nil
      expect(response.error_code).to be(7)
    end
    
    it "should accept additional parameters" do
      api = Clockwork::API.new test_api_key
      message = api.messages.build( :to => '441234123456', :content => 'This is a test message.', :client_id => 'message123' )
      response = message.deliver
      
      expect(response).to be_an_instance_of Clockwork::SMS::Response
      expect(response.success).to be(true)
      expect(response.message_id).not_to be_empty
      expect(response.message.client_id).to match('message123')
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

      responses = api.deliver
      
      expect(responses.count).to be(7)
      expect(responses.first.success).to be(true)
      
      expect(responses.last.success).to be(false)
      expect(responses.last.error_code).to be(10)
    end

    it "should not send huge message if truncate is false" do
      api = Clockwork::API.new test_api_key
      message = api.messages.build( :to => '441234123456', :content => 'a'*500, :truncate => false )
      response = message.deliver
      
      expect(response).to be_an_instance_of Clockwork::SMS::Response
      expect(response.success).to be(false)
      expect(response.message_id).to be_nil
      expect(response.error_code).to be(12)
    end

    it "should send huge message if truncate is true" do
      api = Clockwork::API.new test_api_key
      message = api.messages.build( :to => '441234123456', :content => 'a'*500, :truncate => true )
      response = message.deliver
      
      expect(response).to be_an_instance_of Clockwork::SMS::Response
      expect(response.success).to be(true)
      expect(response.message_id).not_to be_empty
    end

    it "should fail to send unicode snowman if invalid_char_action is error" do
      api = Clockwork::API.new test_api_key
      message = api.messages.build( :to => '441234123456', :content => 'snowman - ☃ - snowman', :invalid_char_action => :error )
      response = message.deliver
      
      expect(response).to be_an_instance_of Clockwork::SMS::Response
      expect(response.success).to be(false)
      expect(response.message_id).to be_nil
      expect(response.error_code).to be(39)
    end

    it "should send unicode snowman if invalid_char_action is replace" do
      api = Clockwork::API.new test_api_key
      message = api.messages.build( :to => '441234123456', :content => 'snowman - ☃ - snowman', :invalid_char_action => :replace )
      response = message.deliver
      
      expect(response).to be_an_instance_of Clockwork::SMS::Response
      expect(response.success).to be(true)
      expect(response.message_id).not_to be_empty
    end

    it "should send unicode snowman if invalid_char_action is remove" do
      api = Clockwork::API.new test_api_key
      message = api.messages.build( :to => '441234123456', :content => 'snowman - ☃ - snowman', :invalid_char_action => :remove )
      response = message.deliver
      
      expect(response).to be_an_instance_of Clockwork::SMS::Response
      expect(response.success).to be(true)
      expect(response.message_id).not_to be_empty
    end

    
  end
  
end