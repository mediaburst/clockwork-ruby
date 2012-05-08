require File.join( File.dirname(__FILE__) + "/spec_helper" )

describe "API" do
  
  let(:test_api_key) { IO.read( File.join( File.dirname(__FILE__) + "/spec_authentication_details" ) ).split("\n")[0] }
  let(:test_username) { IO.read( File.join( File.dirname(__FILE__) + "/spec_authentication_details" ) ).split("\n")[1] }
  let(:test_password) { IO.read( File.join( File.dirname(__FILE__) + "/spec_authentication_details" ) ).split("\n")[2] }
  
  describe "#initialize" do

    it "should raise a Clockwork::InvalidAPIKeyError if no API key is passed" do
      expect { Clockwork::API.new('') }.to raise_error Clockwork::InvalidAPIKeyError
    end
  
    it "should raise a Clockwork::InvalidAPIKeyError if an invalid format of API key is passed" do
      invalid_keys = %w{
      q4353q345325325432
      vsdfgihet8f7yi4u7ttf4guyi
      af7a8f7a8fa7f8a76fa876fa876a876fa875a87
      af7a8f7a8fa7f8a76fa876fa876a876fa875a875a
      }
    
      invalid_keys.each do |k|
        expect { Clockwork::API.new(k) }.to raise_error Clockwork::InvalidAPIKeyError
      end
    end
  
    it "should return a valid instance of Clockwork::API if a valid format of API key is passed" do
      api = Clockwork::API.new 'af7a8f7a8fa7f8a76fa876fa876a876fa875a875'
      api.should be_a_kind_of Clockwork::API
      api.api_key.should == 'af7a8f7a8fa7f8a76fa876fa876a876fa875a875'
    end
  
    it "should raise an ArgumentError if two paramters are passed but either username or password is blank" do
      expect { Clockwork::API.new('username', '') }.to raise_error ArgumentError
      expect { Clockwork::API.new('password', '') }.to raise_error ArgumentError
      expect { Clockwork::API.new('', '') }.to raise_error ArgumentError
    end
  
    it "should return a valid instance of Clockwork::API if a valid username and password are passed" do
      api = Clockwork::API.new 'username', 'password'
      api.should be_a_kind_of Clockwork::API
      api.username.should == 'username'
      api.password.should == 'password'
    end
  
    it "should raise an ArgumentError if more than three parameters are passed" do
      expect { Clockwork::API.new('', '', '') }.to raise_error ArgumentError
    end
  
    it "should set options if a parameters hash is passed along with the API key" do
      api = Clockwork::API.new 'af7a8f7a8fa7f8a76fa876fa876a876fa875a875', { :from => 'A Test', :long => true, :truncate => true, :invalid_char_action => :remove }
      api.from.should == "A Test"
      api.long.should == true
      api.truncate.should == true
      api.invalid_char_action.should == :remove
    end
  
    it "should set options if a parameters hash is passed along with the username and password" do
      api = Clockwork::API.new 'af7a8f7a8fa7f8a76fa876fa876a876fa875a875', { :from => 'A Test', :long => false, :truncate => false, :invalid_char_action => :remove }
      api.from.should == "A Test"
      api.long.should == false
      api.truncate.should == false
      api.invalid_char_action.should == :remove
    end

  end

  describe "#invalid_char_action" do

    it "should raise an ArgumentError if value is not one of :error, :replace, :remove" do
      api = Clockwork::API.new 'af7a8f7a8fa7f8a76fa876fa876a876fa875a875'
      expect { api.invalid_char_action = '123' }.to raise_error ArgumentError
      expect { api.invalid_char_action = 'ERROR' }.to raise_error ArgumentError
    
      # Allow strings, too...
      expect { api.invalid_char_action = 'error' }.to_not raise_error ArgumentError   
    
      # Allowed values
      expect { api.invalid_char_action = :error }.to_not raise_error ArgumentError    
      expect { api.invalid_char_action = :replace }.to_not raise_error ArgumentError
      expect { api.invalid_char_action = :remove }.to_not raise_error ArgumentError
    end

  end

  describe "#credit" do
    
    it "should return the number of messages remaining with a valid username and password" do
      api = Clockwork::API.new test_username, test_password
      api.credit.should be > 0
    end
  
    it "should return the number of messages remaining with an API key" do
      api = Clockwork::API.new test_api_key
      api.credit.should be > 0
    end  
  
  end

  describe "#get_credit" do
  
    it "should return the number of messages remaining with a valid username and password" do
      api = Clockwork::API.new test_username, test_password
      api.get_credit.should be > 0
    end
  
    it "should return the number of messages remaining with an API key" do
      api = Clockwork::API.new test_api_key
      api.get_credit.should be > 0
    end  
    
  end

end