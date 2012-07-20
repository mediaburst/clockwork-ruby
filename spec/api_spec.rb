require File.join( File.dirname(__FILE__) + "/spec_helper" )

describe "API" do
  
  let(:test_api_key) { IO.read( File.join( File.dirname(__FILE__) + "/spec_authentication_details" ) ).split("\n")[0] }
  
  describe "#initialize" do

    it "should raise a Clockwork::Error::InvalidAPIKey if no API key is passed" do
      expect { Clockwork::API.new('') }.to raise_error Clockwork::Error::InvalidAPIKey
    end
  
    it "should raise a Clockwork::Error::InvalidAPIKey if an invalid format of API key is passed" do
      invalid_keys = %w{
      q4353q345325325432
      vsdfgihet8f7yi4u7ttf4guyi
      af7a8f7a8fa7f8a76fa876fa876a876fa875a87
      af7a8f7a8fa7f8a76fa876fa876a876fa875a875a
      }
    
      invalid_keys.each do |k|
        expect { Clockwork::API.new(k) }.to raise_error Clockwork::Error::InvalidAPIKey
      end
    end
  
    it "should return a valid instance of Clockwork::API if a valid format of API key is passed" do
      api = Clockwork::API.new 'af7a8f7a8fa7f8a76fa876fa876a876fa875a875'
      api.should be_a_kind_of Clockwork::API
      api.api_key.should == 'af7a8f7a8fa7f8a76fa876fa876a876fa875a875'
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
    
    it "should return the number of messages remaining with an API key" do
      api = Clockwork::API.new test_api_key
      api.credit.should be > 0
    end  
    
    it "should raise an error with an invalid API key" do
      api = Clockwork::API.new 'a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1'
      expect { api.credit }.to raise_error Clockwork::Error::Generic
    end
  
  end

  describe "#get_credit" do
  
    it "should return the number of messages remaining with an API key" do
      api = Clockwork::API.new test_api_key
      api.get_credit.should be > 0
    end
    
    it "should return the number of messages remaining over standard HTTP" do
      api = Clockwork::API.new test_api_key
      api.use_ssl = false
      api.get_credit.should be > 0
    end      
    
    it "should raise an error with an invalid API key" do
      api = Clockwork::API.new 'a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1'
      expect { api.get_credit }.to raise_error Clockwork::Error::Generic
    end
  
  end

end