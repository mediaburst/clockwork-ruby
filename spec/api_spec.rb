require File.join( File.dirname(__FILE__) + "/spec_helper" )

describe "API", "#initialize" do

  it "should raise a Clockwork::InvalidAPIKeyException if no API key is entered" do
    expect { Clockwork::API.new('') }.to raise_error Clockwork::InvalidAPIKeyException
  end
  
  it "should raise a Clockwork::InvalidAPIKeyException if an invalid API key is entered" do
    invalid_keys = %w{
    q4353q345325325432
    vsdfgihet8f7yi4u7ttf4guyi
    af7a8f7a8fa7f8a76fa876fa876a876fa875a87
    af7a8f7a8fa7f8a76fa876fa876a876fa875a875a
    }
    
    invalid_keys.each do |k|
      expect { Clockwork::API.new(k) }.to raise_error Clockwork::InvalidAPIKeyException
    end
  end
  
  it "should return a valid instance of Clockwork::API if a valid API key is entered" do
    api = Clockwork::API.new 'af7a8f7a8fa7f8a76fa876fa876a876fa875a875'
    api.should be_a_kind_of Clockwork::API
  end

end