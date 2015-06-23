require File.join( File.dirname(__FILE__) + "/spec_helper" )

describe "API" do
  
  let(:test_api_key) { IO.read( File.join( File.dirname(__FILE__) + "/spec_authentication_details" ) ).split("\n")[0] }
  
  describe "#initialize" do

    it "should raise a ClockworkSMS::Error::InvalidAPIKey if no API key is passed" do
      expect { ClockworkSMS::API.new('') }.to raise_error ClockworkSMS::Error::InvalidAPIKey
    end
  
    it "should raise a ClockworkSMS::Error::InvalidAPIKey if an invalid format of API key is passed" do
      invalid_keys = %w{
      q4353q345325325432
      vsdfgihet8f7yi4u7ttf4guyi
      af7a8f7a8fa7f8a76fa876fa876a876fa875a87
      af7a8f7a8fa7f8a76fa876fa876a876fa875a875a
      }
    
      invalid_keys.each do |k|
        expect { ClockworkSMS::API.new(k) }.to raise_error ClockworkSMS::Error::InvalidAPIKey
      end
    end
  
    it "should return a valid instance of ClockworkSMS::API if a valid format of API key is passed" do
      api = ClockworkSMS::API.new 'af7a8f7a8fa7f8a76fa876fa876a876fa875a875'
      expect(api).to be_a_kind_of ClockworkSMS::API
      expect(api.api_key).to match('af7a8f7a8fa7f8a76fa876fa876a876fa875a875')
    end
  
    it "should raise an ArgumentError if more than three parameters are passed" do
      expect { ClockworkSMS::API.new('', '', '') }.to raise_error ArgumentError
    end
  
    it "should set options if a parameters hash is passed along with the API key" do
      api = ClockworkSMS::API.new 'af7a8f7a8fa7f8a76fa876fa876a876fa875a875', { :from => 'A Test', :long => true, :truncate => true, :invalid_char_action => :remove }
      expect(api.from).to match('A Test')
      expect(api.long).to be(true)
      expect(api.truncate).to be(true)
      expect(api.invalid_char_action).to be(2)
    end

  end

  describe "#invalid_char_action" do

    it "should raise an ArgumentError if value is not one of :error, :replace, :remove" do
      api = ClockworkSMS::API.new 'af7a8f7a8fa7f8a76fa876fa876a876fa875a875'
      expect { api.invalid_char_action = '123' }.to raise_error ArgumentError
      expect { api.invalid_char_action = 'ERROR' }.to raise_error ArgumentError
    
      # Allow strings, too...
      expect { api.invalid_char_action = 'error' }.not_to raise_error   
    
      # Allowed values
      expect { api.invalid_char_action = :error }.not_to raise_error    
      expect { api.invalid_char_action = :replace }.not_to raise_error
      expect { api.invalid_char_action = :remove }.not_to raise_error
    end

  end

  describe "#credit" do
    
    it "should return the number of messages remaining with an API key" do
      api = ClockworkSMS::API.new test_api_key
      expect(api.credit).to be > 0
    end  
    
    it "should raise an error with an invalid API key" do
      api = ClockworkSMS::API.new 'a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1'
      expect { api.credit }.to raise_error ClockworkSMS::Error::Generic
    end
    
    it "should return the number of messages remaining over standard HTTP" do
      api = ClockworkSMS::API.new test_api_key
      api.use_ssl = false
      expect(api.credit).to be > 0
    end      
  
  end
  
  describe "#balance" do
    
    it "should return the balance remaining with an API key" do
      api = ClockworkSMS::API.new test_api_key
      balance = api.balance
      expect(balance).to include(:account_type)
      expect(balance).to include(:balance)
      expect(balance).to include(:currency)
    end  
    
    it "should raise an error with an invalid API key" do
      api = ClockworkSMS::API.new 'a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1'
      expect { api.balance }.to raise_error ClockworkSMS::Error::Generic
    end
    
    it "should return the balance over standard HTTP" do
      api = ClockworkSMS::API.new test_api_key
      api.use_ssl = false
      balance = api.balance
      expect(balance).to include(:account_type)
      expect(balance).to include(:balance)
      expect(balance).to include(:currency)
    end      
  
  end

end